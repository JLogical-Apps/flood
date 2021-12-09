import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:rxdart/rxdart.dart';

class StreamQueryRequest<R extends Record, T> extends AbstractQueryRequest<R, ValueStream<FutureValue<T>>> {
  /// The query request to make a stream out of.
  final AbstractQueryRequest<R, T> queryRequest;

  const StreamQueryRequest({required this.queryRequest});

  @override
  Query<R> get query => queryRequest.query;
}
