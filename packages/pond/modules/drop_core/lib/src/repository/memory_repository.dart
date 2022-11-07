import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';

class MemoryRepository with IsRepository {
  @override
  final RepositoryQueryExecutor queryExecutor = MemoryRepositoryQueryExecutor();

  @override
  final RepositoryStateHandler stateHandler = MemoryRepositoryStateHandler();
}

class MemoryRepositoryQueryExecutor implements RepositoryQueryExecutor {}

class MemoryRepositoryStateHandler implements RepositoryStateHandler {}
