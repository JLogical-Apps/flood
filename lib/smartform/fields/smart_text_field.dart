import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';
import 'package:jlogical_utils/widgets/input_field.dart';

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

  const SmartTextField({Key key, @required this.name, this.label, this.initialText, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<String>(
      name: name,
      builder: (str, error) {
        print('error: $error');
        return InputField(
          label: label,
          initialText: context.read<SmartFormCubit>().getValue(name),
          onChange: (s) => context.read<SmartFormCubit>().changeValue(name: name, value: s),
          errorText: error,
        );
      },
      validator: validator,
      initialValue: initialText,
    );
  }
}
