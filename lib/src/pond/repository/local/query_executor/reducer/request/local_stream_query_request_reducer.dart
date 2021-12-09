import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/stream_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalStreamQueryRequestReducer<R extends Record, T>
    extends AbstractLocalQueryRequestReducer<StreamQueryRequest<R, T>, R, ValueStream<FutureValue<T>>> {
  Resolver<AbstractQueryRequest, AbstractLocalQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>
      Function() queryRequestResolverGetter;

  LocalStreamQueryRequestReducer({required this.queryRequestResolverGetter});

  @override
  ValueStream<FutureValue<T>> reduce({
    required List<Record> accumulation,
    required StreamQueryRequest<R, T> queryRequest,
  }) {
    final queryRequestToStream = queryRequest.queryRequest;
    final reducer = queryRequestResolverGetter().resolve(queryRequestToStream);

    return reducer.reduceX(queryRequestToStream) as ValueStream<FutureValue<T>>;
  }

  @override
  ValueStream<FutureValue<ValueStream<FutureValue<T>>>> reduceX(StreamQueryRequest<R, T> queryRequest) {
    throw Exception('Cannot stream a stream of query requests!');
  }
}
