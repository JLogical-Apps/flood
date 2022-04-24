import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IntParameterFormBuilder extends ParameterFormBuilder {
  @override
  String get handledType => 'int';

  Widget buildForm(String name, CommandParameterStub parameterStub) {
    return StyledSmartTextField(
      name: name,
      label: name,
      validators: [
        if (parameterStub.requiredProperty.value!) Validation.required(),
        Validation.isInteger(),
      ],
    );
  }
}
