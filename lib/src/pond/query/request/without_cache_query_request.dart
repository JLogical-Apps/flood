import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class WithoutCacheQueryRequest<R extends Record, T> extends QueryRequest<R, T> {
  final QueryRequest<R, T> queryRequest;

  WithoutCacheQueryRequest({required this.queryRequest});

  @override
  Query<R> get query => queryRequest.query;

  @override
  String toString() {
    return queryRequest.toString();
  }
}
