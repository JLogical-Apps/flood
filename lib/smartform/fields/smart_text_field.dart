import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';
import 'package:jlogical_utils/widgets/input_field.dart';

/// Different formats allowed for SmartTextFields.
enum SmartTextFieldFormat {
  /// Regular text format.
  text,

  /// Multiline text format.
  multiline,

  /// Number, but forced to be an int.
  numberInt,

  /// Can be any number.
  number,

  /// Can be a currency.
  currency,
}

/// SmartField that handles text.
class SmartTextField extends StatelessWidget {
  /// The name of the field.
  final String name;

  /// The label of the field.
  final String label;

  /// The initial text of the field.
  final String initialText;

  /// The validator of the text field.
  final Validator<String> validator;

  /// The format for this field.
  final SmartTextFieldFormat format;

  const SmartTextField({
    Key key,
    @required this.name,
    this.label,
    this.initialText: '',
    this.validator,
    this.format: SmartTextFieldFormat.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<String>(
      name: name,
      builder: (str, error) {
        return InputField(
          label: label,
          keyboardType: _getKeyboardType(format),
          initialText: context.read<SmartFormCubit>().getValue(name),
          onChange: (s) => context.read<SmartFormCubit>().changeValue(name: name, value: s),
          errorText: error,
        );
      },
      validator: validator,
      initialValue: initialText,
    );
  }

  /// Returns the appropriate keyboard type for the given [format].
  TextInputType _getKeyboardType(SmartTextFieldFormat format) {
    switch (format) {
      case SmartTextFieldFormat.text:
        return TextInputType.text;
      case SmartTextFieldFormat.multiline:
        return TextInputType.multiline;
      case SmartTextFieldFormat.number:
        return TextInputType.numberWithOptions(signed: true);
      case SmartTextFieldFormat.numberInt:
        return TextInputType.numberWithOptions(signed: true, decimal: true);
      case SmartTextFieldFormat.currency:
        return TextInputType.number;
    }

    return TextInputType.text;
  }
}
