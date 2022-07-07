import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_date_field.dart';

class StyledDatePortField extends PortFieldWidget<DatePortField, DateTime?, DateTime?>
    with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledDatePortField({
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
  DateTime? getInitialRawValue(DateTime? portValue) {
    return portValue ?? DateTime.now();
  }

  @override
  Widget buildField(BuildContext context, DatePortField field, DateTime? value, Object? exception) {
    return StyledDateField(
      label: label,
      labelText: labelText,
      errorText: getExceptionText(exception),
      date: value,
      onChanged: (value) => setValue(context, value),
    );
  }
}
