import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';
import 'package:jlogical_utils/widgets/input_field.dart';

/// SmartField that handles text.
class SmartTextField extends StatelessWidget {
  /// The name of the field.
  final String name;

  const SmartTextField({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<String>(
      name: name,
      builder: (str) => InputField(
        label: 'Label',
        initialText: context.read<SmartFormCubit>().state.formValues[name],
        onChange: (s) => context.read<SmartFormCubit>().changeValue(name: name, value: s),
      ),
    );
  }
}
