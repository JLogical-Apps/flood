import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/pagination/paginated_query_result.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class PaginatedQueryRequest<E extends Entity>
    extends MapQueryRequest<E, PaginatedQueryResult<State>, PaginatedQueryResult<E>> with EquatableMixin {
  @override
  final QueryRequest<E, PaginatedQueryResult<State>> sourceQueryRequest;

  PaginatedQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<PaginatedQueryResult<E>> doMap(DropCoreContext context, PaginatedQueryResult<State> source) {
    return source.map((state) async {
      final entity = await context.constructEntityFromState<E>(state);
      await entity.throwIfInvalid(null);
      return entity;
    });
  }

  @override
  String toString() {
    return '$query | paginate';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];
}
