import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:runtime_type/type.dart';

class ForAnyRepository with IsRepository {
  @override
  List<RuntimeType> get handledTypes => [];

  @override
  RepositoryQueryExecutor get queryExecutor => throw UnimplementedError();

  @override
  RepositoryStateHandler get stateHandler => throw UnimplementedError();
}
