import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class FirstOrNullQueryRequest<E extends Entity> extends MapQueryRequest<E, State?, E?> with EquatableMixin {
  @override
  final QueryRequest<E, State?> sourceQueryRequest;

  FirstOrNullQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<E?> doMap(DropCoreContext context, State? source) async {
    final entity = await source?.mapIfNonNullAsync((state) => context.constructEntityFromState<E>(state));
    await entity?.throwIfInvalid(null);
    return entity;
  }

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | first?';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];

  @override
  QueryRequest<E, E?> copyWith({Query<E>? query}) {
    return FirstOrNullQueryRequest(sourceQueryRequest: sourceQueryRequest.copyWith(query: query));
  }
}
