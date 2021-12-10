import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/abstract_local_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_query_request_reducer.dart';

import 'reducer/query/local_from_query_reducer.dart';

class LocalQueryExecutor {
  final Map<String, State> stateById;

  const LocalQueryExecutor({required this.stateById});

  Resolver<Query, AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducerResolver() => WrapperResolver([
        LocalFromQueryReducer(stateById: stateById),
        LocalWhereQueryReducer(),
      ]);

  Resolver<AbstractQueryRequest, AbstractLocalQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducerResolver<R extends Record, T>() => WrapperResolver([
            LocalAllQueryRequestReducer<R>(),
          ]);

  Future<T> executeQuery<R extends Record, T>(
    AbstractQueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    final queryChain = queryRequest.query.getQueryChain();

    // [accumulation] represents all the records that match the query.
    Iterable<Record>? accumulation;
    queryChain.forEach((query) {
      final queryReducer = getQueryReducerResolver().resolve(query);
      accumulation = queryReducer.reduce(aggregate: accumulation, query: query);
    });

    final _accumulation = accumulation ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final accumulationList = _accumulation.cast<R>().toList();

    final queryRequestReducer = getQueryRequestReducerResolver<R, T>().resolve(queryRequest);
    final output = queryRequestReducer.reduce(accumulation: accumulationList, queryRequest: queryRequest);

    return output;
  }
}
