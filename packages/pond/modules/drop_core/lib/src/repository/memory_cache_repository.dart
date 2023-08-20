import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class MemoryCacheRepository with IsRepositoryWrapper {
  @override
  late final Repository repository;

  final BehaviorSubject<Map<String, State>> stateByIdX = BehaviorSubject.seeded({});
  final List<QueryRequest> queriesRun = [];

  MemoryCacheRepository({required Repository sourceRepository}) {
    repository = sourceRepository.withListener(
      onStateRetrieved: (state) => stateByIdX.value = stateByIdX.value.copy()..set(state.id!, state),
    );
  }

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(onReset: (context, _) async {
          stateByIdX.value = {};
          queriesRun.clear();
        }),
      ];

  @override
  late final RepositoryQueryExecutor queryExecutor = MemoryCacheRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = MemoryCacheRepositoryStateHandler(repository: this);
}

class MemoryCacheRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final MemoryCacheRepository repository;

  MemoryCacheRepositoryQueryExecutor({required this.repository});

  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  late StateQueryExecutor stateQueryExecutor = StateQueryExecutor.fromStatesX(
    statesX: repository.stateByIdX
        .mapWithValue((stateById) => stateById.values.map((state) => statePersister.inflate(state)).toList()),
    dropContext: repository.context.dropCoreComponent,
  );

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) async {
    if (QueryRequestModifier.findIsWithoutCache(queryRequest)) {
      return await repository.repository.executeQuery(queryRequest);
    }

    if (!repository.queriesRun.contains(queryRequest)) {
      repository.queriesRun.add(queryRequest);
      await repository.repository.executeQuery(queryRequest);
    }

    return await stateQueryExecutor.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    if (QueryRequestModifier.findIsWithoutCache(queryRequest)) {
      return repository.repository.executeQueryX(queryRequest);
    }

    if (!repository.queriesRun.contains(queryRequest)) {
      repository.queriesRun.add(queryRequest);
      repository.repository.executeQuery(queryRequest);
    }

    return stateQueryExecutor.executeQueryX(queryRequest);
  }
}

class MemoryCacheRepositoryStateHandler with IsRepositoryStateHandler {
  final MemoryCacheRepository repository;

  MemoryCacheRepositoryStateHandler({required this.repository});

  @override
  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    state = await repository.repository.update(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, statePersister.persist(state));
    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    state = await repository.repository.delete(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
    return state;
  }
}
