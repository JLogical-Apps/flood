import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BoolParameterFormBuilder extends ParameterFormBuilder {
  @override
  String get handledType => 'bool';

  Widget buildForm(CommandParameterStub parameterStub) {
    return Column(
      children: [
        StyledSmartBoolField(
          name: parameterStub.nameProperty.value!,
          labelText: parameterStub.displayNameProperty.value,
        ),
        if (parameterStub.descriptionProperty.value != null)
          StyledBodyText(
            parameterStub.descriptionProperty.value!,
            textOverrides: StyledTextOverrides(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }
}
