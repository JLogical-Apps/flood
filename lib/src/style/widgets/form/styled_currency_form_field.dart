import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_text_field.dart';

class StyledCurrencyFormField extends FormFieldModelWidget<double> {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final double? suggestedValue;

  final bool enabled;

  StyledCurrencyFormField({
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
  Widget buildField(BuildContext context, double value) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      initialText: '$value',
      hintText: suggestedValue?.toString(),
      onChanged: (text) => setValue(context, double.tryParse(text) ?? 0),
      enabled: enabled,
    );
  }
}
