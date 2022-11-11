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
  late final RepositoryStateHandler stateHandler = MemoryRepositoryStateHandler(repository: this);
}

class MemoryRepositoryQueryExecutor implements RepositoryQueryExecutor {
  final MemoryRepository repository;

  MemoryRepositoryQueryExecutor({required this.repository});
}

class MemoryRepositoryStateHandler implements RepositoryStateHandler {
  final MemoryRepository repository;

  MemoryRepositoryStateHandler({required this.repository});

  @override
  Future<void> update(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, state);
  }

  @override
  Future<void> delete(State state) async {
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
  }
}
