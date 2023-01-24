import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FirstOrNullQueryRequest<E extends Entity> with IsMapQueryRequest<State?, E?> {
  @override
  final QueryRequest<State?> sourceQueryRequest;

  FirstOrNullQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<E?> doMap(DropCoreContext context, State? source) {
    return source?.mapIfNonNull((state) => context.constructEntityFromState<E>(state));
  }

  @override
  String toString() {
    return '$query | first?';
  }
}
