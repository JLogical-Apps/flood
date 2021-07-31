import 'package:flutter/material.dart';

import '../../../jlogical_utils.dart';
import '../smart_form_controller.dart';
import '../smart_form_field.dart';
import '../validation/validation.dart';

/// A simple text field.
class SmartTextField extends SmartFormField<String> {
  /// The label of the field.
  final String? label;

  /// The suggested value to show if no input is typed in.
  /// Adds this as the value to the SmartFormField if no input has been typed in.
  final String? suggestedValue;

  /// The keyboard type to show.
  final TextInputType keyboardType;

  /// Whether to obscure the text.
  final bool obscureText;

  /// The number of lines to show.
  final int maxLines;

  /// The line color to use. If null, then uses primaryColor.
  final Color? lineColor;

  SmartTextField({
    Key? key,
    required String name,
    required this.label,
    String? initialValue,
    this.suggestedValue,
    List<Validation<String>>? validators,
    this.keyboardType: TextInputType.text,
    this.obscureText: false,
    this.maxLines: 1,
    bool enabled: true,
    this.lineColor,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue ?? '',
          validators: validators ?? const [],
          enabled: enabled,
        );

  @override
  Widget buildForm(BuildContext context, String value, String? error, bool enabled, SmartFormController smartFormController) {
    return InputField(
      label: label,
      keyboardType: keyboardType,
      initialText: value,
      hintText: suggestedValue,
      onChange: (text) => smartFormController.setData(name: name, value: text),
      errorText: error,
      obscureText: obscureText,
      maxLines: maxLines,
      lineColor: lineColor,
      enabled: enabled,
    );
  }
}
