import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';

/// Styles for the bool fields.
enum SmartBoolFieldStyle {
  checkbox,
  $switch,
}

/// Bool field for a SmartForm.
class SmartBoolField extends StatelessWidget {
  final String name;

  final Widget child;

  final bool initiallyChecked;

  final Validator<bool> validator;

  final SmartBoolFieldStyle style;

  const SmartBoolField({
    Key key,
    this.name,
    this.child,
    this.validator,
    this.initiallyChecked: false,
    this.style: SmartBoolFieldStyle.checkbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartField<bool>(
      name: name,
      builder: (value, error) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                style == SmartBoolFieldStyle.checkbox
                    ? Checkbox(
                        value: value,
                        onChanged: (value) {
                          SmartFormCubit smartFormCubit = context.bloc<SmartFormCubit>();
                          smartFormCubit.changeValue(name: name, value: value);
                        },
                      )
                    : Switch(
                        value: value,
                        onChanged: (value) {
                          SmartFormCubit smartFormCubit = context.bloc<SmartFormCubit>();
                          smartFormCubit.changeValue(name: name, value: value);
                        },
                      ),
                child,
              ],
            ),
            if (error != null) Text(error, style: TextStyle(color: Colors.red)),
          ],
        );
      },
      validator: validator == null ? null : (value) => validator(value as bool),
      initialValue: initiallyChecked,
    );
  }
}
