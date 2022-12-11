import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class AllQueryRequest<E extends Entity> with IsMapQueryRequest<List<State>, List<E>> {
  @override
  final QueryRequest<List<State>> sourceQueryRequest;

  AllQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<List<E>> doMap(DropCoreContext context, List<State> states) {
    return states.map((state) => context.constructEntityFromState<E>(state)).toList();
  }
}
