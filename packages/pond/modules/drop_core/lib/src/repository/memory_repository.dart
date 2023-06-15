import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class MemoryRepository with IsRepository {
  final BehaviorSubject<Map<String, State>> stateByIdX = BehaviorSubject.seeded({});

  @override
  late final RepositoryQueryExecutor queryExecutor = MemoryRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      MemoryRepositoryStateHandler(repository: this).withEntityLifecycle(context.coreDropComponent);
}

class MemoryRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  final MemoryRepository repository;

  MemoryRepositoryQueryExecutor({required this.repository});

  @override
  late final RepositoryQueryExecutor queryExecutor = _getQueryExecutor();

  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.coreDropComponent);

  RepositoryQueryExecutor _getQueryExecutor() {
    final stateByIdX = repository.stateByIdX;

    return StateQueryExecutor.fromStatesX(
      dropContext: repository.context.coreDropComponent,
      statesX: stateByIdX
          .mapWithValue((stateById) => stateById.values.map((state) => statePersister.inflate(state)).toList()),
    );
  }
}

class MemoryRepositoryStateHandler with IsRepositoryStateHandler {
  final MemoryRepository repository;

  MemoryRepositoryStateHandler({required this.repository});

  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.coreDropComponent);

  @override
  Future<State> onUpdate(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, statePersister.persist(state));
    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
    return state;
  }
}
