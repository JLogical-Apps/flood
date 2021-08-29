import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledSmartDateField extends SmartFormField<DateTime> {
  /// The label of the field.
  final String? label;

  StyledSmartDateField({
    required String name,
    DateTime? initialValue,
    bool enabled: true,
    List<Validation<DateTime>>? validators,
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
      enabled: enabled,
      errorText: error,
      initialDate: value,
      onChanged: (value) => smartFormController.setData(name: name, value: value),
    );
  }
}
