import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IntParameterFormBuilder extends ParameterFormBuilder {
  @override
  String get handledType => 'int';

  Widget buildForm(CommandParameterStub parameterStub) {
    return Column(
      children: [
        StyledSmartTextField(
          name: parameterStub.nameProperty.value!,
          label: parameterStub.displayNameProperty.value!,
          validators: [
            if (parameterStub.requiredProperty.value!) Validation.required(),
            Validation.isInteger(),
          ],
        ),
        if (parameterStub.descriptionProperty.value != null)
          StyledBodyText(
            parameterStub.descriptionProperty.value!,
            textOverrides: StyledTextOverrides(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  @override
  transformValue(formValue) {
    return int.tryParse(formValue);
  }
}
