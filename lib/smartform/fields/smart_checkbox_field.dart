import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';

/// Checkbox field for a SmartForm.
class SmartCheckboxField extends StatelessWidget {
  final String name;

  final String label;

  final bool initiallyChecked;

  final Validator<bool> validator;

  const SmartCheckboxField({
    Key key,
    this.name,
    this.label,
    this.validator,
    this.initiallyChecked: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<bool>(
      name: name,
      builder: (value, error) {
        return CheckboxListTile(
          value: value,
          title: Text(label),
          subtitle: error != null ? Text(error, style: TextStyle(color: Colors.red)) : null,
          onChanged: (value) {
            SmartFormCubit smartFormCubit = context.bloc<SmartFormCubit>();
            smartFormCubit.changeValue(name: name, value: value);
          },
        );
      },
      validator: validator == null ? null : (value) => validator(value as bool),
      initialValue: initiallyChecked,
    );
  }
}
