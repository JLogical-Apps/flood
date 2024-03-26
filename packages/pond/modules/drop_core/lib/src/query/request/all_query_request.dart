import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class AllQueryRequest<E extends Entity> extends MapQueryRequest<E, List<State>, List<E>> with EquatableMixin {
  @override
  final QueryRequest<E, List<State>> sourceQueryRequest;

  AllQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<List<E>> doMap(DropCoreContext context, List<State> source) async {
    final entities = await Future.wait(source.map((state) => context.constructEntityFromState<E>(state)));
    await Future.wait(entities.map((entity) => entity.throwIfInvalid(null)));
    return entities;
  }

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | all';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];

  @override
  QueryRequest<E, List<E>> copyWith({Query<E>? query}) {
    return AllQueryRequest(sourceQueryRequest: sourceQueryRequest.copyWith(query: query));
  }
}
