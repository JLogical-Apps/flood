import 'package:drop_core/src/state/persistence/json/json_state_persister_modifier.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class StateJsonStatePersisterModifier extends JsonStatePersisterModifier {
  final RuntimeType Function(String name) runtimeTypeGetter;

  StateJsonStatePersisterModifier({required this.runtimeTypeGetter});

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    final newData = data.copy();
    newData.replaceWhere((key, value) => value is State, (key, value) {
      final state = value as State;
      return {
        if (state.id != null) State.idField: state.id,
        if (state.type != null) State.typeField: state.type!.name,
        ...state.data,
      };
    });
    return newData;
  }

  @override
  Map<String, dynamic> inflate(Map<String, dynamic> data) {
    final newData = data.copy();
    newData.replaceWhere((key, value) => value is Map<String, dynamic> && value.containsKey(State.typeField),
        (key, value) => State.fromMap(value as Map<String, dynamic>, runtimeTypeGetter: runtimeTypeGetter));
    return newData;
  }
}
