import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:utils_core/utils_core.dart';

class StateStatePersisterModifier extends StatePersisterModifier {
  final DropCoreContext context;

  StateStatePersisterModifier({required this.context});

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    return replaceStatefulWithData(data);
  }

  Map<String, dynamic> replaceStatefulWithData(Map<String, dynamic> data) {
    return data
        .replaceWhereTraversed((key, value) => value is Stateful, (key, value) {
          final stateful = value as Stateful;
          final state = stateful.getState(context);
          return persistState(state);
        })
        .replaceWhereTraversed(
          (key, value) => value is List<Stateful>,
          (key, value) => (value as List<Stateful>).map((stateful) {
            final state = stateful.getState(context);
            return persistState(state);
          }).toList(),
        )
        .cast<String, dynamic>();
  }

  Map<String, dynamic> persistState(State state) {
    return {
      if (state.id != null) State.idField: state.id,
      if (state.type != null) State.typeField: state.type!.name,
      ...replaceStatefulWithData(state.data),
    };
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
                  typeContext: context.typeContext,
                ))
        .replaceWhereTraversed(
      (key, value) =>
          value is List &&
          value.every((item) => item is Map && item.isA<String, dynamic>() && item.containsKey(State.typeField)),
      (key, value) {
        return (value as List)
            .cast<Map>()
            .map((data) => State.fromMap(
                  replaceDataWithState(data.cast<String, dynamic>()),
                  typeContext: context.typeContext,
                ))
            .toList();
      },
    ).cast<String, dynamic>();
    return newData;
  }
}
