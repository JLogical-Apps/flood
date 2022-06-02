import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledCurrencyPortField extends PortFieldWidget<CurrencyPortField, int?, String>
    with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final String? suggestedValue;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledCurrencyPortField({
    super.key,
    required super.name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  });

  @override
  String getInitialRawValue(int? portValue) {
    return portValue?.formatCentsAsCurrency() ?? '';
  }

  @override
  Widget buildField(BuildContext context, CurrencyPortField field, String value, Object? exception) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      errorText: getExceptionText(exception),
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      initialText: value,
      hintText: suggestedValue,
      onChanged: (text) => setValue(context, text),
      enabled: enabled,
    );
  }
}
