import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/display_name_value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/label_value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObjectBehavior implements Validator<ValueObject, String> {
  void fromState(DropCoreContext context, State state);

  State modifyState(DropCoreContext context, State state);

  Future<State> modifyStateForRepository(DropCoreContext context, State state);

  static DisplayNameValueObjectBehavior displayName(String? displayName) {
    return DisplayNameValueObjectBehavior(displayNameGetter: () => displayName);
  }

  static DisplayNameValueObjectBehavior dynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectBehavior(displayNameGetter: displayNameGetter);
  }

  static LabelValueObjectBehavior label(String? Function() labelGetter) {
    return LabelValueObjectBehavior(labelGetter: labelGetter);
  }
}

mixin IsValueObjectBehavior implements ValueObjectBehavior {
  @override
  void fromState(DropCoreContext context, State state) {}

  @override
  State modifyState(DropCoreContext context, State state) {
    return state;
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    return state;
  }

  @override
  FutureOr<String?> onValidate(ValueObject valueObject) async {
    return null;
  }
}
