import 'dart:async';

import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:equatable/equatable.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class QueryRequest<E, T> with EquatableMixin {
  Query get query;
}

extension QueryRequestExtensions<E extends Entity, T> on QueryRequest<E, T> {
  MapQueryRequest<E, T, R> map<R>(FutureOr<R> Function(CoreDropContext context, T source) mapper) {
    return MapQueryRequest(sourceQueryRequest: this, mapper: mapper);
  }

  Model<T> toModel(CoreDropContext context) {
    return Model.fromValueStream(context.executeQueryX(this));
  }

  Future<T> get(CoreDropContext context) {
    return context.executeQuery(this);
  }

  ValueStream<FutureValue<T>> getX(CoreDropContext context) {
    return context.executeQueryX(this);
  }
}
