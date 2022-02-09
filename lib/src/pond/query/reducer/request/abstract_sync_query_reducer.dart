import 'dart:async';

import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractSyncQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T, C>
    extends AbstractQueryRequestReducer<QR, R, T, C> {
  Future<T> reduce({required C accumulation, required QR queryRequest}) async {
    return reduceSync(accumulation: accumulation, queryRequest: queryRequest);
  }

  T reduceSync({required C accumulation, required QR queryRequest});
}
