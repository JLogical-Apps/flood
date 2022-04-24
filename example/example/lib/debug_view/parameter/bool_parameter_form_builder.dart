import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BoolParameterFormBuilder extends ParameterFormBuilder {
  @override
  String get handledType => 'bool';

  Widget buildForm(String name, CommandParameterStub parameterStub) {
    return StyledSmartBoolField(
      name: name,
      labelText: name,
    );
  }
}
