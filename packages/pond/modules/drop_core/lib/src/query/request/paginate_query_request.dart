import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/pagination/paginated_query_result.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';

class PaginatedQueryRequest<E extends Entity>
    with IsMapQueryRequest<E, PaginatedQueryResult<State>, PaginatedQueryResult<E>>, EquatableMixin {
  @override
  final QueryRequest<E, PaginatedQueryResult<State>> sourceQueryRequest;

  PaginatedQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<PaginatedQueryResult<E>> doMap(DropCoreContext context, PaginatedQueryResult<State> statesPage) {
    return statesPage.map((state) => context.constructEntityFromState<E>(state));
  }

  @override
  String toString() {
    return '$query | paginate';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];
}
