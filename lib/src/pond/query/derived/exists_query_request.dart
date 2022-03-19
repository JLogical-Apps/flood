import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

import '../../record/record.dart';
import 'derived_query_request.dart';

class ExistsQueryRequest<R extends Record> extends DerivedQueryRequest<R, bool> {
  @override
  final Query<R> query;

  ExistsQueryRequest({required this.query});

  @override
  Future<bool> deriveQueryResult(QueryExecutor queryExecutor) async {
    final anyEntity = await queryExecutor.executeQuery(query.firstOrNull());
    return anyEntity != null;
  }

  @override
  ValueStream<FutureValue<bool>> deriveQueryResultX(QueryExecutorX queryExecutorX) {
    return queryExecutorX
        .executeQueryX(query.firstOrNull())
        .mapWithValue((maybeAnyEntity) => maybeAnyEntity.mapIfPresent((someEntity) => someEntity != null));
  }

  @override
  String toString() {
    return '$query | exists';
  }
}
