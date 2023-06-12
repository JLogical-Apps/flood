import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/core_drop_component.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
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
  RepositoryQueryExecutor get queryExecutor {
    final stateByIdX = repository.stateByIdX;

    return StateQueryExecutor(
      dropContext: repository.context.locate<CoreDropComponent>(),
      statesX: stateByIdX.mapWithValue((stateById) => stateById.values.toList()),
    );
  }
}

class MemoryRepositoryStateHandler with IsRepositoryStateHandler {
  final MemoryRepository repository;

  MemoryRepositoryStateHandler({required this.repository});

  @override
  Future<State> onUpdate(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, state);
    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
    return state;
  }
}
