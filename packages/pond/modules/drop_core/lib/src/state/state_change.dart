import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class StateChange {
  final State? oldState;
  final State newState;

  StateChange({required this.oldState, required this.newState});

  Map<String, dynamic>? getModifiedDataOrNull() {
    if (oldState == null) {
      return null;
    }

    final differences = <String, dynamic>{};
    newState.data.forEach((key, value) {
      if (oldState!.data.containsKey(key)) {
        if (oldState!.data[key] != value) {
          differences[key] = value;
        }
      } else {
        differences[key] = value;
      }
    });
    oldState!.data.where((key, value) => !newState.data.containsKey(key)).forEach((key, value) {
      differences[key] = null;
    });

    return differences;
  }

  Map<String, dynamic> getModifiedDataOrNew() {
    return getModifiedDataOrNull() ?? newState.data;
  }
}
