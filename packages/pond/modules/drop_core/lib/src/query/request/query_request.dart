import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/without_cache_query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:equatable/equatable.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class QueryRequest<E, T> with EquatableMixin {
  Query get query;

  String prettyPrint(DropCoreContext context);
}

extension QueryRequestExtensions<E extends Entity, T> on QueryRequest<E, T> {
  MapQueryRequest<E, T, R> map<R>(FutureOr<R> Function(DropCoreContext context, T source) mapper) {
    return MapQueryRequest.create(sourceQueryRequest: this, mapper: mapper);
  }

  WithoutCacheQueryRequest<E, T> withoutCache() {
    return WithoutCacheQueryRequest(queryRequest: this);
  }

  Model<T> toModel(DropCoreContext context) {
    return Model.fromValueStream(
      context.executeQueryX(this),
      onLoad: () => context.executeQuery(this.withoutCache()),
    );
  }

  Future<T> get(DropCoreContext context) {
    return context.executeQuery(this);
  }

  ValueStream<FutureValue<T>> getX(DropCoreContext context) {
    return context.executeQueryX(this);
  }
}

mixin IsQueryRequest<E extends Entity, T> implements QueryRequest<E, T> {
  @override
  bool? get stringify => true;
}

abstract class QueryRequestWrapper<E extends Entity, T> extends QueryRequest<E, T> {
  QueryRequest<E, T> get queryRequest;

  @override
  Query<Entity> get query => queryRequest.query;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => queryRequest.props;
}
