import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import '../../../patterns/export_core.dart';
import '../query.dart';
import '../reducer/query/abstract_sync_query_reducer.dart';

mixin WithSyncResolverQueryExecutor<C> implements QueryExecutor {
  List<AbstractSyncQueryReducer<Query, C>> getSyncQueryReducers(QueryRequest queryRequest);

  List<AbstractSyncQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, C>>
      getSyncQueryRequestReducers<R extends Record>();

  Resolver<Query, AbstractSyncQueryReducer<Query, C>> getQueryReducerResolver(QueryRequest queryRequest) =>
      WrapperResolver(getSyncQueryReducers(queryRequest));

  Resolver<QueryRequest<R, dynamic>, AbstractSyncQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, C>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver(getSyncQueryRequestReducers<R>());

  T executeQuerySync<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    final queryChain = queryRequest.query.getQueryChain();

    // [accumulation] represents all the records that match the query.
    C? accumulation;
    for (final query in queryChain) {
      final queryReducer = getQueryReducerResolver(queryRequest).resolve(query);
      accumulation = queryReducer.reduceSync(accumulation: accumulation, query: query);
    }

    final _accumulation = accumulation ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final queryRequestReducer = getQueryRequestReducerResolver<R>().resolve(queryRequest);
    final output = queryRequestReducer.reduceSync(accumulation: _accumulation, queryRequest: queryRequest);

    return output;
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    final queryChain = queryRequest.query.getQueryChain();

    // [accumulation] represents all the records that match the query.
    C? accumulation;
    for (final query in queryChain) {
      final queryReducer = getQueryReducerResolver(queryRequest).resolve(query);
      accumulation = queryReducer.reduceSync(accumulation: accumulation, query: query);
    }

    final _accumulation = accumulation ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final queryRequestReducer = getQueryRequestReducerResolver<R>().resolve(queryRequest);
    final output = await queryRequestReducer.reduce(accumulation: _accumulation, queryRequest: queryRequest);

    return output;
  }
}
