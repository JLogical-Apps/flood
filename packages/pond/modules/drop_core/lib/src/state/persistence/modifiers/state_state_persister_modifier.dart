import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class StateStatePersisterModifier extends StatePersisterModifier {
  final CoreDropContext context;

  StateStatePersisterModifier({required this.context});

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    return replaceStatefulWithData(data);
  }

  Map<String, dynamic> replaceStatefulWithData(Map<String, dynamic> data) {
    return data.replaceWhereTraversed((key, value) => value is Stateful, (key, value) {
      final stateful = value as Stateful;
      final state = stateful.getState(context);
      return {
        if (state.id != null) State.idField: state.id,
        if (state.type != null) State.typeField: state.type!.name,
        ...replaceStatefulWithData(state.data),
      };
    }).cast<String, dynamic>();
  }

  @override
  Map<String, dynamic> inflate(Map<String, dynamic> data) {
    return replaceDataWithState(data);
  }

  Map<String, dynamic> replaceDataWithState(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed(
            (key, value) => value is Map && value.isA<String, dynamic>() && value.containsKey(State.typeField),
            (key, value) => State.fromMap(
                  replaceDataWithState((value as Map).cast<String, dynamic>()),
                  runtimeTypeGetter: (name) => context.typeContext.getByName(name),
                ))
        .cast<String, dynamic>();
    return newData;
  }
}
