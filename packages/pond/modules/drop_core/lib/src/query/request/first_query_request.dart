import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class FirstQueryRequest<E extends Entity> with IsMapQueryRequest<E, State?, E>, EquatableMixin {
  @override
  final QueryRequest<E, State?> sourceQueryRequest;

  FirstQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<E> doMap(DropCoreContext context, State? source) async {
    final entity = await context.constructEntityFromState<E>(source ?? (throw Exception('Could not find state!')));
    await entity.throwIfInvalid(null);
    return entity;
  }

  @override
  String toString() {
    return '$query | first';
  }

  @override
  List<Object?> get props => [sourceQueryRequest];
}
