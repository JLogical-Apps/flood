import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class FromStateQueryReducer extends StateQueryReducer<FromQuery> {
  final CoreDropContext dropContext;

  FromStateQueryReducer({required this.dropContext});

  @override
  Iterable<State> reduce(FromQuery query, Iterable<State> currentStates) {
    if (query.entityType == typeOf<Entity>()) {
      return currentStates.where((state) => state.type != null);
    }

    final queryEntityRuntimeType = dropContext.typeContext.getRuntimeTypeRuntime(query.entityType);
    return currentStates.where((state) =>
        state.type != null &&
        (state.type == queryEntityRuntimeType || state.type!.parents.contains(queryEntityRuntimeType)));
  }
}
