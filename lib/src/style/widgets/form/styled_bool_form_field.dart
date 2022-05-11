import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../../../form/export_core.dart';
import '../input/styled_checkbox.dart';

class StyledBoolFormField extends FormFieldModelWidget<BoolFormField, bool> {
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
  Widget buildField(BuildContext context, BoolFormField field, bool value) {
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
