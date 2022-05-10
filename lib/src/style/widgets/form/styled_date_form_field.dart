import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_date_field.dart';

class StyledDateFormField extends FormFieldModelWidget<DateTime> {
  final String? labelText;

  final Widget? label;

  StyledDateFormField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, DateTime value) {
    return StyledDateField(
      label: label,
      labelText: labelText,
      date: value,
      onChanged: (value) => setValue(context, value),
    );
  }
}
