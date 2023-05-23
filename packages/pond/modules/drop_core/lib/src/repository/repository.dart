import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/adapting_repository.dart';
import 'package:drop_core/src/repository/memory_repository.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/repository/type/for_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/for_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/with_embedded_type_repository.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:environment_core/environment_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class Repository implements CorePondComponent, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  List<RuntimeType> get handledTypes => [];

  static MemoryRepository memory() {
    return MemoryRepository();
  }

  static Repository list(List<Repository> repositories) {
    return RepositoryListWrapper(repositories);
  }

  static Repository adapting(Repository Function(EnvironmentConfigCoreComponent environment) repositoryGetter) {
    return AdaptingRepository(repositoryGetter);
  }
}

extension RepositoryExtension on Repository {
  Future<State> update(Stateful stateful) async {
    var state = stateful.getState(context.locate<DropCoreComponent>());

    state = await onUpdate(state);

    return state;
  }

  Future<State> delete(Stateful state) {
    return onDelete(state.getState(context.locate<DropCoreComponent>()));
  }

  ForTypeRepository<E, V> forType<E extends Entity<V>, V extends ValueObject>(
    E Function() entityConstructor,
    V Function() valueObjectConstructor, {
    required String entityTypeName,
    required String valueObjectTypeName,
    List<Type>? entityParents,
    List<Type>? valueObjectParents,
  }) {
    return ForTypeRepository<E, V>(
      repository: this,
      entityConstructor: entityConstructor,
      valueObjectConstructor: valueObjectConstructor,
      entityTypeName: entityTypeName,
      valueObjectTypeName: valueObjectTypeName,
      entityParents: entityParents ?? [],
      valueObjectParents: valueObjectParents ?? [],
    );
  }

  ForAbstractTypeRepository<E, V> forAbstractType<E extends Entity<V>, V extends ValueObject>({
    required String entityTypeName,
    required String valueObjectTypeName,
    List<Type>? entityParents,
    List<Type>? valueObjectParents,
  }) {
    return ForAbstractTypeRepository<E, V>(
      repository: this,
      entityTypeName: entityTypeName,
      valueObjectTypeName: valueObjectTypeName,
      entityParents: entityParents ?? [],
      valueObjectParents: valueObjectParents ?? [],
    );
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
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
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

  @override
  CorePondContext get context => repository.context;

  @override
  set context(CorePondContext context) => repository.context = context;

  @override
  List<CorePondComponentBehavior> get behaviors => repository.behaviors;

  @override
  Future<State> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<State> onDelete(State state) => stateHandler.onDelete(state);

  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
}
