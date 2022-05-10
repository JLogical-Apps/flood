import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_checkbox.dart';

class StyledBoolFormField extends FormFieldModelWidget<bool> {
  final String? labelText;

  final Widget? label;

  StyledBoolFormField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, bool value) {
    return StyledCheckbox(
      value: value,
      label: label,
      labelText: labelText,
      onChanged: (value) {
        setValue(context, value);
      },
    );
  }
}
