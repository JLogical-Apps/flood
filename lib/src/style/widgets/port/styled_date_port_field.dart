import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_date_field.dart';

class StyledDatePortField extends PortFieldWidget<DatePortField, DateTime> {
  final String? labelText;

  final Widget? label;

  StyledDatePortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, DatePortField field, DateTime value) {
    return StyledDateField(
      label: label,
      labelText: labelText,
      date: value,
      onChanged: (value) => setValue(context, value),
    );
  }
}
