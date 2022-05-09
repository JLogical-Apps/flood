import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_text_field.dart';

class StyledStringFormField extends FormFieldModelBuilder<String> {
  /// The label of the field.
  final String? label;

  /// The suggested value to show if no input is typed in.
  /// Adds this as the value to the SmartFormField if no input has been typed in.
  final String? suggestedValue;

  /// The keyboard type to show.
  final TextInputType keyboardType;

  /// The capitalization to use for the text field.
  final TextCapitalization textCapitalization;

  /// Whether to obscure the text.
  final bool obscureText;

  /// The maximum length of characters in the field. If null, no limit is enforced.
  final int? maxLength;

  /// The number of lines to show.
  final int maxLines;

  /// Whether the field is enabled.
  final bool enabled;

  StyledStringFormField({
    Key? key,
    required String name,
    required this.label,
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
  Widget buildField(BuildContext context, String value) {
    return StyledTextField(
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
