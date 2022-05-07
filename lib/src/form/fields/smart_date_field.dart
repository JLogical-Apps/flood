import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../widgets/export.dart';
import '../smart_form_controller.dart';
import '../smart_form_field.dart';
import '../validation/validation.dart';

class SmartDateField extends SmartFormField<DateTime> {
  /// The label of the field.
  final String? label;

  SmartDateField({
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
    return InputField(
      key: ValueKey(value),
      readonly: true,
      initialText: value.formatDate(isLong: true),
      enabled: enabled,
      errorText: error,
      label: label ?? '',
      onTap: () async {
        print('test');
        final result = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastDate: DateTime.now().add(Duration(days: 1000)),
        );
        if (result != null) smartFormController.setData(name: name, value: result);
      },
    );
  }
}
