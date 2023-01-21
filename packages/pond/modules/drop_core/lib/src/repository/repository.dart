import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/memory_repository.dart';
import 'package:drop_core/src/repository/repository_id_generator.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/repository/type/for_abstract_type_repository.dart';
import 'package:drop_core/src/repository/type/for_type_repository.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class Repository implements CorePondComponent, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  List<RuntimeType> get handledTypes => [];

  RepositoryIdGenerator get idGenerator => RepositoryIdGenerator.uuid();

  static MemoryRepository memory() {
    return MemoryRepository();
  }

  static Repository list(List<Repository> repositories) {
    return RepositoryListWrapper(repositories);
  }
}

extension RepositoryExtension on Repository {
  Future<State> update(Stateful stateful) async {
    var state = stateful.getState(context.locate<DropCoreComponent>());

    if (state.isNew) {
      state = state.withId(await idGenerator.generateId());
    }

    await stateHandler.update(state);

    return state;
  }

  Future<void> delete(Stateful state) {
    return stateHandler.delete(state.getState(context.locate<DropCoreComponent>()));
  }

  ForTypeRepository forType<E extends Entity<V>, V extends ValueObject>(
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

  ForAbstractTypeRepository forAbstractType<E extends Entity<V>, V extends ValueObject>({
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
}

mixin IsRepository implements Repository, IsRepositoryStateHandlerWrapper, IsRepositoryQueryExecutorWrapper {
  @override
  List<RuntimeType> get handledTypes => [];

  @override
  RepositoryIdGenerator get idGenerator => RepositoryIdGenerator.uuid();

  @override
  List<CorePondComponentBehavior> get behaviors => [];

  @override
  late CorePondContext context;

  @override
  Future<void> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<void> onDelete(State state) => stateHandler.onDelete(state);

  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
}

abstract class RepositoryWrapper implements Repository {
  Repository get repository;

  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryIdGenerator get idGenerator => repository.idGenerator;

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler;

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor;
}

mixin IsRepositoryWrapper implements RepositoryWrapper, RepositoryStateHandlerWrapper, RepositoryQueryExecutorWrapper {
  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryIdGenerator get idGenerator => repository.idGenerator;

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
  Future<void> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<void> onDelete(State state) => stateHandler.onDelete(state);

  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
}
