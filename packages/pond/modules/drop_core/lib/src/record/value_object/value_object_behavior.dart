import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/display_name_value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObjectBehavior implements Validator<ValueObject, String> {
  void fromState(State state);

  State modifyState(State state);

  static DisplayNameValueObjectBehavior displayName(String? displayName) {
    return DisplayNameValueObjectBehavior(displayNameGetter: () => displayName);
  }

  static DisplayNameValueObjectBehavior dynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectBehavior(displayNameGetter: displayNameGetter);
  }
}

mixin IsValueObjectBehavior implements ValueObjectBehavior {
  @override
  void fromState(State state) {}

  @override
  State modifyState(State state) {
    return state;
  }

  @override
  FutureOr<String?> onValidate(ValueObject valueObject) async {
    return null;
  }
}
