import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/derived/derived_query_request.dart';
import 'package:rxdart/rxdart.dart';

class MappedQueryRequest<R extends Record, T, S> extends DerivedQueryRequest<R, S> {
  final QueryRequest<R, T> queryRequest;

  final S Function(T result) mapper;

  MappedQueryRequest({required this.queryRequest, required this.mapper});

  @override
  Query<R> get query => queryRequest.query;

  @override
  Future<S> deriveQueryResult(QueryExecutor queryExecutor) async {
    final result = await queryExecutor.executeQuery(queryRequest);
    return mapper(result);
  }

  @override
  ValueStream<FutureValue<S>> deriveQueryResultX(QueryExecutorX queryExecutorX) {
    return queryExecutorX.executeQueryX(queryRequest).mapWithValue((result) => result.mapIfPresent(mapper));
  }
}
