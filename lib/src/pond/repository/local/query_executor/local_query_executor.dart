import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_query_request_reducer.dart';

import 'reducer/query/local_from_query_reducer.dart';

class LocalQueryExecutor implements QueryExecutor {
  final Map<String, Record> recordById;

  const LocalQueryExecutor({required this.recordById});

  List<QueryReducer<Query, Iterable<Record>>> getQueryReducers() => [
        LocalFromQueryReducer(recordById: recordById),
      ];

  List<QueryRequestReducer<dynamic, R, dynamic, List<Record>>> getQueryRequestReducers<R extends Record>() => [
        LocalAllQueryRequestReducer<R>(),
      ];

  @override
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    Iterable<Record>? aggregate;
    final queryChain = queryRequest.getQueryChain();

    queryChain.forEach((query) {
      final queryReducer = getQueryReducers().firstWhere((reducer) => reducer.shouldReduce(query));
      aggregate = queryReducer.reduce(aggregate: aggregate, query: query);
    });

    final _aggregate = aggregate ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final aggregateList = _aggregate.cast<R>().toList();

    final queryRequestReducer =
        getQueryRequestReducers<R>().firstWhere((reducer) => reducer.shouldReduce(queryRequest));
    return queryRequestReducer.reduce(aggregate: aggregateList, queryRequest: queryRequest);
  }
}
