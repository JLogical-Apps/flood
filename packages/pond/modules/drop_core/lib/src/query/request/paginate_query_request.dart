import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/pagination/paginated_query_result.dart';
import 'package:drop_core/src/query/query.dart';
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
  Future<PaginatedQueryResult<E>> doMap(DropCoreContext context, PaginatedQueryResult<State> source) async {
    return await source.withPageMapper(
      pageMapper: (states) => Future.wait(states.map((state) async {
        final entity = await context.constructEntityFromState<E>(state);
        await entity.throwIfInvalid(null);
        return entity;
      })),
      reversePageMapper: (entities) => entities.map((entity) => entity.getState(context)).toList(),
    );
  }

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | paginate';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];

  @override
  QueryRequest<E, PaginatedQueryResult<E>> copyWith({Query<E>? query}) {
    return PaginatedQueryRequest(sourceQueryRequest: sourceQueryRequest.copyWith(query: query));
  }
}
