import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_text_field.dart';

/// Styled SmartTextField that uses a [StyledTextField].
class StyledSmartTextField extends SmartFormField<String> {
  /// The label of the field.
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Adds this as the value to the SmartFormField if no input has been typed in.
  final String? suggestedValue;

  final Color? backgroundColor;

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

  StyledSmartTextField({
    Key? key,
    required String name,
    this.label,
    this.labelText,
    String? initialValue,
    this.suggestedValue,
    List<Validation<String>>? validators,
    this.backgroundColor,
    this.keyboardType: TextInputType.text,
    this.textCapitalization: TextCapitalization.sentences,
    this.obscureText: false,
    this.maxLength,
    this.maxLines: 1,
    bool enabled: true,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue ?? '',
          validators: (validators ?? const []) +
              [
                if (maxLength != null) Validation.maxLength(maxLength: maxLength),
              ],
          enabled: enabled,
        );

  @override
  Widget buildForm(
      BuildContext context, String value, String? error, bool enabled, SmartFormController smartFormController) {
    return StyledTextField(
      label: label,
      labelText: labelText,
      keyboardType: keyboardType,
      initialText: value,
      hintText: suggestedValue,
      onChanged: (text) => smartFormController.setData(name: name, value: text),
      errorText: error,
      backgroundColor: backgroundColor,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      enabled: enabled,
    );
  }
}
