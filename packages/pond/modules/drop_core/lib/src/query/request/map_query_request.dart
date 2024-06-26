import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

abstract class MapQueryRequest<E extends Entity, S, T> extends QueryRequest<E, T> {
  QueryRequest<E, S> get sourceQueryRequest;

  static MapQueryRequest<E, S, T> create<E extends Entity, S, T>({
    required QueryRequest<E, S> sourceQueryRequest,
    required FutureOr<T> Function(DropCoreContext context, S source) mapper,
  }) =>
      _MapQueryRequestImpl<E, S, T>(
        sourceQueryRequest: sourceQueryRequest,
        mapper: mapper,
      );

  FutureOr<T> doMap(DropCoreContext context, S source);

  @override
  Query<E> get query => sourceQueryRequest.query;
}

class _MapQueryRequestImpl<E extends Entity, S, T> extends MapQueryRequest<E, S, T> {
  @override
  final QueryRequest<E, S> sourceQueryRequest;

  final FutureOr<T> Function(DropCoreContext context, S source) mapper;

  _MapQueryRequestImpl({required this.sourceQueryRequest, required this.mapper});

  @override
  Future<T> doMap(DropCoreContext context, S source) async {
    return await mapper(context, source);
  }

  @override
  List<Object?> get props => [sourceQueryRequest];

  @override
  Query<E> get query => sourceQueryRequest.query;

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | mapped';
  }

  @override
  QueryRequest<E, T> copyWith({Query<E>? query}) {
    return _MapQueryRequestImpl(sourceQueryRequest: sourceQueryRequest.copyWith(query: query), mapper: mapper);
  }
}
