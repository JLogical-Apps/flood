import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class FirstQueryRequest<E extends Entity> with IsMapQueryRequest<State?, E> {
  @override
  final QueryRequest<State?> sourceQueryRequest;

  FirstQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<E> doMap(DropCoreContext context, State? source) {
    return context.constructEntityFromState<E>(source ?? (throw Exception('Could not find state!')));
  }
}
