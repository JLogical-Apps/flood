import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StringParameterFormBuilder extends ParameterFormBuilder {
  @override
  String get handledType => 'string';

  Port getForm(CommandParameterStub parameterStub) {
    return Port(
      fields: [
        StringPortField(name: parameterStub.nameProperty.value!)
            .withSimpleValidatorIf(Validator.required(), addIf: parameterStub.requiredProperty.value!),
      ],
    );
  }

  Widget buildForm(CommandParameterStub parameterStub) {
    return Column(
      children: [
        StyledTextPortField(
          name: parameterStub.nameProperty.value!,
          labelText: parameterStub.displayNameProperty.value!,
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
