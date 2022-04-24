import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class ParameterFormBuilder extends Wrapper<CommandParameterStub> {
  String get handledType;

  Widget buildForm(String name, CommandParameterStub parameterStub);

  @override
  bool shouldWrap(CommandParameterStub value) {
    return value.typeProperty.value == handledType;
  }
}
