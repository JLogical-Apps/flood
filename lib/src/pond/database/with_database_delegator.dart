import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/future_value.dart';
import '../query/request/query_request.dart';
import '../record/record.dart';
import '../repository/entity_repository.dart';
import 'database.dart';

mixin WithDatabaseDelegator implements Database {
  Database get database;

  EntityRepository? getRepositoryRuntimeOrNull(Type entityType) {
    return database.getRepositoryRuntimeOrNull(entityType);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return database.executeQueryX<R, T>(queryRequest);
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return database.executeQuery<R, T>(queryRequest);
  }
}
