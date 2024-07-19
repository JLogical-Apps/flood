import 'dart:async';

import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/cloud_repository.dart';
import 'package:drop_core/src/repository/device_sync_cache_repository.dart';
import 'package:drop_core/src/repository/entity_lifecycle_repository.dart';
import 'package:drop_core/src/repository/environmental_repository.dart';
import 'package:drop_core/src/repository/file_repository.dart';
import 'package:drop_core/src/repository/listener_repository.dart';
import 'package:drop_core/src/repository/memory_cache_repository.dart';
import 'package:drop_core/src/repository/memory_repository.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/repository/security/repository_security.dart';
import 'package:drop_core/src/repository/security/security_repository.dart';
import 'package:drop_core/src/repository/type/for_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/for_any_repository.dart';
import 'package:drop_core/src/repository/type/for_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_type_repository.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:environment_core/environment_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Repository implements CorePondComponent, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  List<RuntimeType> get handledTypes => [];

  static Repository list(List<Repository> repositories) {
    return RepositoryListWrapper(repositories);
  }

  static ForAnyRepository forAny() => ForAnyRepository();

  static ForTypeRepository<E, V> forType<E extends Entity<V>, V extends ValueObject>(
    E Function() entityConstructor,
    V Function() valueObjectConstructor, {
    required String entityTypeName,
    required String valueObjectTypeName,
    List<Type>? entityParents,
    List<Type>? valueObjectParents,
  }) {
    return ForTypeRepository<E, V>(
      entityConstructor: entityConstructor,
      valueObjectConstructor: valueObjectConstructor,
      entityTypeName: entityTypeName,
      valueObjectTypeName: valueObjectTypeName,
      entityParents: entityParents ?? [],
      valueObjectParents: valueObjectParents ?? [],
    );
  }

  static ForAbstractTypeRepository<E, V> forAbstractType<E extends Entity<V>, V extends ValueObject>({
    required String entityTypeName,
    required String valueObjectTypeName,
    List<Type>? entityParents,
    List<Type>? valueObjectParents,
  }) {
    return ForAbstractTypeRepository<E, V>(
      entityTypeName: entityTypeName,
      valueObjectTypeName: valueObjectTypeName,
      entityParents: entityParents ?? [],
      valueObjectParents: valueObjectParents ?? [],
    );
  }
}

extension RepositoryExtension on Repository {
  Future<State> update(Stateful stateful) async {
    var state = stateful.getState(context.locate<DropCoreComponent>());
    state = await onUpdate(state);
    return state;
  }

  Future<E> updateEntity<E extends Entity<V>, V extends ValueObject>(
    E entity, [
    FutureOr Function(V newValueObject)? updater,
  ]) async {
    final valueObjectType = V == ValueObject ? entity.valueObjectType : V;
    var valueObjectRuntimeType = context.dropCoreComponent.getRuntimeTypeRuntime(valueObjectType);
    if (valueObjectRuntimeType.isAbstract) {
      valueObjectRuntimeType = context.dropCoreComponent.getRuntimeTypeRuntime(entity.valueObjectType);
    }

    final newValueObject = valueObjectRuntimeType.createInstance() as V;

    if (entity.hasValue) {
      newValueObject.idToUse = entity.value.idToUse;
      newValueObject.entity = entity;
      newValueObject.copyFrom(context.dropCoreComponent, entity.value);
    }

    await updater?.call(newValueObject);
    entity.value = newValueObject;
    await entity.throwIfInvalid(null);
    final newState = await update(entity);
    entity
      ..id = newState.id
      ..isNew = newState.isNew;
    return await context.dropCoreComponent.constructEntityFromState(newState);
  }

  Future<State> delete(Stateful state) {
    return onDelete(state.getState(context.locate<DropCoreComponent>()));
  }

  WithEmbeddedTypeRepository<V> withEmbeddedType<V extends ValueObject>(
    V Function() valueObjectConstructor, {
    required String valueObjectTypeName,
    List<Type>? valueObjectParents,
  }) {
    return WithEmbeddedTypeRepository<V>(
      repository: this,
      valueObjectConstructor: valueObjectConstructor,
      valueObjectTypeName: valueObjectTypeName,
      valueObjectParents: valueObjectParents ?? [],
    );
  }

  WithEmbeddedAbstractTypeRepository<V> withEmbeddedAbstractType<V extends ValueObject>({
    required String valueObjectTypeName,
    List<Type>? valueObjectParents,
  }) {
    return WithEmbeddedAbstractTypeRepository<V>(
      repository: this,
      valueObjectTypeName: valueObjectTypeName,
      valueObjectParents: valueObjectParents ?? [],
    );
  }

  ListenerRepository withListener({
    final FutureOr Function(State state)? onStateRetrieved,
  }) {
    return ListenerRepository(
      repository: this,
      onStateRetrieved: onStateRetrieved,
    );
  }

  Repository memory({bool includeLifecycle = true, BehaviorSubject<Map<String, State>>? stateByIdX}) {
    final repository = MemoryRepository(repository: this, stateByIdX: stateByIdX);
    return includeLifecycle ? repository.withEntityLifecycle() : repository;
  }

  Repository file(String rootPath, {bool includeLifecycle = true}) {
    final repository = FileRepository(rootPath: rootPath, repository: this);
    return includeLifecycle ? repository.withEntityLifecycle() : repository;
  }

  Repository cloud(String rootPath, {bool includeLifecycle = true}) {
    final repository = CloudRepository(rootPath: rootPath, childRepository: this);
    return includeLifecycle ? repository.withEntityLifecycle() : repository;
  }

  Repository environmental(
    Repository Function(Repository repository, EnvironmentConfigCoreComponent config) repositoryGetter,
  ) {
    return EnvironmentalRepository(
      childRepository: this,
      repositoryGetter: repositoryGetter,
    );
  }

  Repository adapting(String rootPath) {
    return environmental((repository, context) {
      if (context.environment == EnvironmentType.static.testing) {
        return repository.memory();
      } else if (context.environment == EnvironmentType.static.device) {
        return repository.file(rootPath).withMemoryCache();
      } else {
        return repository.cloud(rootPath).withMemoryCache();
      }
    });
  }

  Repository syncing(String rootPath) {
    return environmental((repository, context) {
      if (context.environment == EnvironmentType.static.testing) {
        return repository.memory();
      } else if (context.environment == EnvironmentType.static.device) {
        return repository.file(rootPath).withMemoryCache();
      } else {
        if (context.platform == Platform.web) {
          return repository.cloud(rootPath).withMemoryCache();
        }
        return repository.cloud(rootPath, includeLifecycle: false).withDeviceSyncCache().withMemoryCache();
      }
    });
  }

  Repository adaptingToDevice(String rootPath) {
    return environmental((repository, context) {
      if (context.environment == EnvironmentType.static.testing) {
        return repository.memory();
      } else {
        return repository.file(rootPath).withMemoryCache();
      }
    });
  }

  MemoryCacheRepository withMemoryCache() {
    return MemoryCacheRepository(sourceRepository: this);
  }

  DeviceSyncCacheRepository withDeviceSyncCache() {
    return DeviceSyncCacheRepository(sourceRepository: this);
  }

  SecurityRepository withSecurity(RepositorySecurity repositorySecurity) {
    return SecurityRepository(repository: this, repositorySecurity: repositorySecurity);
  }

  Repository withEntityLifecycle() {
    return EntityLifecycleRepository(repository: this);
  }
}

mixin IsRepository implements Repository, IsRepositoryStateHandlerWrapper, IsRepositoryQueryExecutorWrapper {
  @override
  List<RuntimeType> get handledTypes => [];

  @override
  List<CorePondComponentBehavior> get behaviors => [];

  @override
  late CorePondContext context;

  @override
  Future<State> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<State> onDelete(State state) => stateHandler.onDelete(state);

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
}

abstract class RepositoryWrapper implements Repository {
  Repository get repository;

  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler;

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor;
}

mixin IsRepositoryWrapper implements RepositoryWrapper, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler;

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor;

  late CorePondContext _context;

  @override
  CorePondContext get context => _context;

  @override
  set context(CorePondContext context) {
    _context = context;
    repository.context = context;
  }

  @override
  List<CorePondComponentBehavior> get behaviors => repository.behaviors;

  @override
  Future<State> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<State> onDelete(State state) => stateHandler.onDelete(state);

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
}
