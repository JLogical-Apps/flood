import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:equatable/equatable.dart';

abstract class MapQueryRequest<E extends Entity, S, T> implements QueryRequest<E, T> {
  QueryRequest<E, S> get sourceQueryRequest;

  factory MapQueryRequest({
    required QueryRequest<E, S> sourceQueryRequest,
    required FutureOr<T> Function(DropCoreContext context, S source) mapper,
  }) =>
      _MapQueryRequestImpl(
        sourceQueryRequest: sourceQueryRequest,
        mapper: mapper,
      );

  FutureOr<T> doMap(DropCoreContext context, S source);
}

mixin IsMapQueryRequest<E extends Entity, S, T> implements MapQueryRequest<E, S, T> {
  @override
  Query get query => sourceQueryRequest.query;
}

class _MapQueryRequestImpl<E extends Entity, S, T> with IsMapQueryRequest<E, S, T>, EquatableMixin {
  @override
  final QueryRequest<E, S> sourceQueryRequest;

  final FutureOr<T> Function(DropCoreContext context, S source) mapper;

  _MapQueryRequestImpl({required this.sourceQueryRequest, required this.mapper});

  @override
  Future<T> doMap(DropCoreContext context, S source) async {
    return await mapper(context, source);
  }

  @override
  List<Object?> get props => [sourceQueryRequest, mapper];
}
