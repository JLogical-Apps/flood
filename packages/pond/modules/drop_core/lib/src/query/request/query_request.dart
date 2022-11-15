import 'dart:async';

import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';

abstract class QueryRequest<T> {
  final Query query;

  QueryRequest({required this.query});
}

extension QueryRequestExtensions<T> on QueryRequest<T> {
  MapQueryRequest<T, R> map<R>(FutureOr<R> Function(T source) mapper) {
    return MapQueryRequest(sourceQueryRequest: this, mapper: mapper);
  }
}
