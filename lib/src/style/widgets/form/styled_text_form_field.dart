import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../../../form/export_core.dart';
import '../input/styled_text_field.dart';

class StyledTextFormField extends FormFieldModelWidget<StringFormField, String> {
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

  StyledTextFormField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.keyboardType: TextInputType.text,
    this.textCapitalization: TextCapitalization.sentences,
    this.obscureText: false,
    this.maxLength,
    this.maxLines: 1,
    this.enabled: true,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, StringFormField field, String value) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      keyboardType: keyboardType,
      initialText: value,
      hintText: suggestedValue,
      onChanged: (text) => setValue(context, text),
      errorText: null,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      enabled: enabled,
    );
  }
}
