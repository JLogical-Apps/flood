import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class BlankRepository with IsRepository {
  @override
  RepositoryQueryExecutor get queryExecutor => BlankRepositoryQueryExecutor();

  @override
  RepositoryStateHandler get stateHandler => BlankRepositoryStateHandler();
}

class BlankRepositoryQueryExecutor implements RepositoryQueryExecutor {
  @override
  bool handlesQuery(QueryRequest queryRequest) {
    return false;
  }

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) {
    throw UnimplementedError();
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) {
    throw UnimplementedError();
  }
}

class BlankRepositoryStateHandler implements RepositoryStateHandler {
  @override
  Future<State> onDelete(State state) {
    throw UnimplementedError();
  }

  @override
  Future<State> onUpdate(State state) {
    throw UnimplementedError();
  }
}
