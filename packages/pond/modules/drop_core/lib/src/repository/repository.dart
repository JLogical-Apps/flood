import 'dart:async';

import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/adapting_repository.dart';
import 'package:drop_core/src/repository/cloud_repository.dart';
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
import 'package:drop_core/src/repository/type/for_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_type_repository.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class Repository implements CorePondComponent, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  List<RuntimeType> get handledTypes => [];

  static Repository list(List<Repository> repositories) {
    return RepositoryListWrapper(repositories);
  }

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
    final newValueObject = context.dropCoreComponent.construct(valueObjectType) as V;

    if (entity.hasValue) {
      newValueObject.state = entity.value.getState(context.dropCoreComponent);
    }

    await updater?.call(newValueObject);
    entity.value = newValueObject;
    await entity.throwIfInvalid(null);
    final newState = await update(entity);
    entity.id = newState.id;
    return context.dropCoreComponent.constructEntityFromState(newState);
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
    final Function(State state)? onStateRetrieved,
  }) {
    return ListenerRepository(
      repository: this,
      onStateRetrieved: onStateRetrieved,
    );
  }

  MemoryRepository memory() {
    return MemoryRepository(repository: this);
  }

  FileRepository file(String rootPath) {
    return FileRepository(rootPath: rootPath, childRepository: this);
  }

  CloudRepository cloud(String rootPath) {
    return CloudRepository(rootPath: rootPath, childRepository: this);
  }

  Repository adapting(String rootPath) {
    return AdaptingRepository(rootPath: rootPath, childRepository: this);
  }

  MemoryCacheRepository withMemoryCache() {
    return MemoryCacheRepository(sourceRepository: this);
  }

  SecurityRepository withSecurity(RepositorySecurity repositorySecurity) {
    return SecurityRepository(repository: this, repositorySecurity: repositorySecurity);
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
  StatePersister get statePersister => stateHandler.statePersister;

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
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
  StatePersister get statePersister => stateHandler.statePersister;

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
}
