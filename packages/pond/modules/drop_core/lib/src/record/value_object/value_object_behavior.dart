import 'package:drop_core/src/record/value_object/display_name_value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';

abstract class ValueObjectBehavior {
  void fromState(State state) {}

  void fromStateUnsafe(State state) {}

  State modifyState(State state) {
    return state;
  }

  State modifyStateUnsafe(State state) {
    return modifyState(state);
  }

  static DisplayNameValueObjectBehavior displayName(String? displayName) {
    return DisplayNameValueObjectBehavior(displayNameGetter: () => displayName);
  }

  static DisplayNameValueObjectBehavior dynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectBehavior(displayNameGetter: displayNameGetter);
  }
}
