import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:equatable/equatable.dart';
import 'package:model_core/model_core.dart';

abstract class QueryRequest<T> with EquatableMixin {
  Query get query;
}

extension QueryRequestExtensions<T> on QueryRequest<T> {
  MapQueryRequest<T, R> map<R>(FutureOr<R> Function(DropCoreContext context, T source) mapper) {
    return MapQueryRequest(sourceQueryRequest: this, mapper: mapper);
  }

  Model<T> toModel(DropCoreContext context) {
    return Model.fromValueStream(context.executeQueryX(this));
  }
}
