import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_checkbox.dart';

class StyledCheckboxPortField extends PortFieldWidget<BoolPortField, bool> {
  final String? labelText;

  final Widget? label;

  StyledCheckboxPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, BoolPortField field, bool value) {
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
