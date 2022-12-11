import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';

abstract class QueryRequest<T> {
  Query get query;
}

mixin IsQueryRequest<T> implements QueryRequest<T> {}

extension QueryRequestExtensions<T> on QueryRequest<T> {
  MapQueryRequest<T, R> map<R>(FutureOr<R> Function(DropCoreContext context, T source) mapper) {
    return MapQueryRequest(sourceQueryRequest: this, mapper: mapper);
  }
}
