import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import '../query.dart';

mixin WithResolverQueryExecutor<C> implements QueryExecutor {
  List<AbstractQueryReducer<Query, C>> getQueryReducers(QueryRequest queryRequest);

  List<AbstractQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, C>>
      getQueryRequestReducers<R extends Record>();

  Resolver<Query, AbstractQueryReducer<Query, C>> getQueryReducerResolver(QueryRequest queryRequest) =>
      WrapperResolver(getQueryReducers(queryRequest));

  Resolver<QueryRequest<R, dynamic>, AbstractQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, C>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver(getQueryRequestReducers<R>());

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    final queryChain = queryRequest.query.getQueryChain();

    // [accumulation] represents all the records that match the query.
    C? accumulation;
    for (final query in queryChain) {
      final queryReducer = getQueryReducerResolver(queryRequest).resolve(query);
      accumulation = await queryReducer.reduce(accumulation: accumulation, query: query);
    }

    final _accumulation = accumulation ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final queryRequestReducer = getQueryRequestReducerResolver<R>().resolve(queryRequest);
    final output = await queryRequestReducer.reduce(accumulation: _accumulation, queryRequest: queryRequest);

    return output;
  }
}
