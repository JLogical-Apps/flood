import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class ParameterFormBuilder extends Wrapper<CommandParameterStub> {
  String get handledType;

  Widget buildForm(CommandParameterStub parameterStub);

  /// Transforms the [formValue] into a value to be passed along to the command as an arg.
  dynamic transformValue(dynamic formValue) => formValue;

  @override
  bool shouldWrap(CommandParameterStub value) {
    return value.typeProperty.value == handledType;
  }
}
