import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledCurrencyPortField extends PortFieldWidget<DoublePortField, double>
    with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final double? suggestedValue;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledCurrencyPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, DoublePortField field, double value, Object? exception) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      errorText: getExceptionText(exception),
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      initialText: '$value',
      hintText: suggestedValue?.toString(),
      onChanged: (text) => setValue(context, double.tryParse(text) ?? 0),
      enabled: enabled,
    );
  }
}
