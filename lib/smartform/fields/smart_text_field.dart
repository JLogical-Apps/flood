import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';

import '../../jlogical_utils.dart';

/// SmartField that handles text.
class SmartTextField extends StatelessWidget {
  /// The name of the field.
  final String name;

  /// The label of the field.
  final String? label;

  /// The initial text of the field.
  final String initialText;

  /// The validator of the text field.
  final Validator<String>? validator;

  /// The keyboard type to show.
  final TextInputType keyboardType;

  /// Whether to obscure the text.
  final bool obscureText;

  /// The number of lines to show.
  final int maxLines;

  /// Whether this is enabled.
  final bool isEnabled;

  /// The line color to use. If null, then uses primaryColor.
  final Color? lineColor;

  const SmartTextField({
    Key? key,
    required this.name,
    this.label,
    this.initialText: '',
    this.validator,
    this.keyboardType: TextInputType.text,
    this.obscureText: false,
    this.maxLines: 1,
    this.isEnabled: true,
    this.lineColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<String>(
      name: name,
      builder: (str, error) {
        return InputField(
          label: label,
          keyboardType: keyboardType,
          initialText: BlocProvider.of<SmartFormCubit>(context).getValue(name),
          onChange: (s) => BlocProvider.of<SmartFormCubit>(context).changeValue(name: name, value: s),
          errorText: error,
          obscureText: obscureText,
          maxLines: maxLines,
          enabled: isEnabled,
          lineColor: lineColor,
        );
      },
      validator: validator == null ? null : (value) => validator?.call((value as String?) ?? ''),
      initialValue: initialText,
    );
  }
}
