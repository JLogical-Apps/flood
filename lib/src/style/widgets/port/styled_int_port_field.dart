import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledIntPortField extends PortFieldWidget<IntPortField, int> {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final int? suggestedValue;

  final bool enabled;

  StyledIntPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.enabled: true,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, IntPortField field, int value) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      keyboardType: TextInputType.numberWithOptions(signed: true),
      initialText: '$value',
      hintText: suggestedValue?.toString(),
      onChanged: (text) => setValue(context, int.tryParse(text) ?? 0),
      enabled: enabled,
    );
  }
}
