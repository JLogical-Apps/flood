import 'dart:async';

import 'package:drop_core/src/query/request/query_request.dart';

class MapQueryRequest<S, T> extends QueryRequest<T> {
  final QueryRequest<S> sourceQueryRequest;
  final FutureOr<T> Function(S source) mapper;

  MapQueryRequest({required this.sourceQueryRequest, required this.mapper}) : super(query: sourceQueryRequest.query);

  Future<T> map(S source) async {
    return await mapper(source);
  }
}
