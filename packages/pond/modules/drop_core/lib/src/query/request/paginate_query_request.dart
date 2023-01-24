import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class PaginatedQueryRequest<E extends Entity> with IsMapQueryRequest<QueryResultPage<State>, QueryResultPage<E>> {
  @override
  final QueryRequest<QueryResultPage<State>> sourceQueryRequest;

  PaginatedQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<QueryResultPage<E>> doMap(DropCoreContext context, QueryResultPage<State> statesPage) {
    return statesPage.map((state) => context.constructEntityFromState<E>(state));
  }

  @override
  String toString() {
    return '$query | paginate';
  }
}
