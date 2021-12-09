import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalAllQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<AllQueryRequest<R>, R, List<Record>> {
  @override
  List<R> reduce({
    required List<Record> accumulation,
    required AllQueryRequest<R> queryRequest,
  }) {
    return accumulation.cast<R>().toList();
  }

  @override
  ValueStream<FutureValue<List<Record>>> reduceX(AllQueryRequest<R> queryRequest) {
    // TODO: implement reduceX
    throw UnimplementedError();
  }
}
