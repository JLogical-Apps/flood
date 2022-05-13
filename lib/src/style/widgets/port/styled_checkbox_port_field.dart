import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_checkbox.dart';

class StyledCheckboxPortField extends PortFieldWidget<BoolPortField, bool> with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledCheckboxPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, BoolPortField field, bool value, Object? exception) {
    return StyledCheckbox(
      value: value,
      label: label,
      labelText: labelText,
      errorText: getExceptionText(exception),
      onChanged: (value) {
        setValue(context, value);
      },
    );
  }
}
