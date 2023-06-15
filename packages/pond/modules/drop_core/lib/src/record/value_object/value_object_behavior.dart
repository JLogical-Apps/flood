import 'dart:async';

import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/display_name_value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObjectBehavior with EquatableMixin implements Validator<ValueObject, String> {
  void fromState(CoreDropContext context, State state);

  State modifyState(CoreDropContext context, State state);

  static DisplayNameValueObjectBehavior displayName(String? displayName) {
    return DisplayNameValueObjectBehavior(displayNameGetter: () => displayName);
  }

  static DisplayNameValueObjectBehavior dynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectBehavior(displayNameGetter: displayNameGetter);
  }
}

mixin IsValueObjectBehavior implements ValueObjectBehavior {
  @override
  void fromState(CoreDropContext context, State state) {}

  @override
  State modifyState(CoreDropContext context, State state) {
    return state;
  }

  @override
  FutureOr<String?> onValidate(ValueObject valueObject) async {
    return null;
  }

  @override
  bool? get stringify => false;
}
