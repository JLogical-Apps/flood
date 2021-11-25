import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_query_request_reducer.dart';

import 'reducer/query/local_from_query_reducer.dart';

class LocalQueryExecutor implements QueryExecutor {
  final Map<String, State> stateById;

  const LocalQueryExecutor({required this.stateById});

  Resolver<Query, AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducerResolver() => WrapperResolver([
        LocalFromQueryReducer(stateById: stateById),
        LocalWhereQueryReducer(),
      ]);

  Resolver<AbstractQueryRequest, AbstractQueryRequestReducer<dynamic, R, dynamic, List<Record>>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver([
            LocalAllQueryRequestReducer<R>(),
          ]);

  @override
  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest, {Transaction? transaction}) async {
    final queryChain = queryRequest.getQueryChain();

    // [aggregate] represents all the records that match the query.
    Iterable<Record>? aggregate;
    queryChain.forEach((query) {
      final queryReducer = getQueryReducerResolver().resolve(query);
      aggregate = queryReducer.reduce(aggregate: aggregate, query: query);
    });

    final _aggregate = aggregate ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final aggregateList = _aggregate.cast<R>().toList();

    final queryRequestReducer = getQueryRequestReducerResolver<R>().resolve(queryRequest);
    final output = queryRequestReducer.reduce(aggregate: aggregateList, queryRequest: queryRequest);

    return output;
  }
}
