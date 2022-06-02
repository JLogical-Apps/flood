import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledTextPortField extends PortFieldWidget<StringPortField, String?, String> with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final String? suggestedValue;

  final TextInputType keyboardType;

  final TextCapitalization textCapitalization;

  final bool obscureText;

  /// The maximum length of characters in the field. If null, no limit is enforced.
  final int? maxLength;

  /// The number of lines to show.
  final int maxLines;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledTextPortField({
    super.key,
    required super.name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.keyboardType: TextInputType.text,
    this.textCapitalization: TextCapitalization.sentences,
    this.obscureText: false,
    this.maxLength,
    this.maxLines: 1,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  });

  @override
  String getInitialRawValue(String? portValue) {
    return portValue ?? '';
  }

  @override
  Widget buildField(BuildContext context, StringPortField field, String? value, Object? exception) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      errorText: getExceptionText(exception),
      keyboardType: keyboardType,
      initialText: value,
      hintText: suggestedValue,
      onChanged: (text) => setValue(context, text),
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      enabled: enabled,
    );
  }
}
