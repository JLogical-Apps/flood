import 'dart:async';

import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractSyncQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T, C>
    extends AbstractQueryRequestReducer<QR, R, T, C> {
  Future<T> reduce({required C accumulation, required QR queryRequest}) async {
    var value = reduceSync(accumulation: accumulation, queryRequest: queryRequest);

    final inflatedValue = await inflate(value);
    if (inflatedValue != null) {
      value = inflatedValue;
    }

    return value;
  }

  Future<T> inflate(T output) async => output;

  T reduceSync({required C accumulation, required QR queryRequest});
}
