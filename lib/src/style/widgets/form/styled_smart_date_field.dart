import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_date_field.dart';

/// Styled SmartDateField that uses a [StyledDateField].
class StyledSmartDateField extends SmartFormField<DateTime> {
  final String? labelText;

  final Widget? label;

  StyledSmartDateField({
    required String name,
    DateTime? initialValue,
    bool enabled: true,
    List<Validation<DateTime>>? validators,
    this.labelText,
    this.label,
  }) : super(
          name: name,
          initialValue: initialValue ?? DateTime.now(),
          enabled: enabled,
          validators: validators ?? const [],
        );

  @override
  Widget buildForm(
      BuildContext context, DateTime value, String? error, bool enabled, SmartFormController smartFormController) {
    return StyledDateField(
      label: label,
      labelText: labelText,
      errorText: error,
      date: value,
      onChanged: enabled ? (value) => smartFormController.setData(name: name, value: value) : null,
    );
  }
}
