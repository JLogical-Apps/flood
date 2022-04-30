import 'dart:async';

import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import '../../../../patterns/export_core.dart';

abstract class AbstractQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T, C>
    with WithSubtypeWrapper<QR, QueryRequest<R, dynamic>>
    implements Wrapper<QueryRequest<R, dynamic>> {
  Future<T> reduce({required C accumulation, required QR queryRequest});
}
