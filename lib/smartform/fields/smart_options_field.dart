import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';

import '../../jlogical_utils.dart';

/// SmartField that handles a list of options.
class SmartOptionsField<T> extends StatelessWidget {
  /// The name of the field.
  final String name;

  /// The label of the field.
  final String? label;

  /// The options to choose from.
  final List<T> options;

  /// The initial value of the field.
  final T? initialValue;

  /// Builder for an option to a widget.
  /// Also must handle the null option if no selection.
  /// Defaults to a ListTile with the [title] as the value.toString().
  final Widget Function(T?)? builder;

  /// The validator of the text field.
  final Validator<T?>? validator;

  /// Whether this is enabled.
  final bool isEnabled;

  /// The line color to use. If null, then uses primaryColor.
  final Color? lineColor;

  const SmartOptionsField({
    Key? key,
    required this.name,
    this.label,
    required this.options,
    this.initialValue,
    this.builder,
    this.validator,
    this.isEnabled: true,
    this.lineColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _builder = builder ?? (item) => ListTile(title: Text(item.toString()));
    return SmartField<T?>(
      name: name,
      builder: (value, error) {
        return DropdownButtonFormField<T?>(
          value: value,
          items: (options.cast<T?>() + [null])
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: _builder(value),
                    onTap: () => BlocProvider.of<SmartFormCubit>(context).changeValue(name: name, value: value),
                  ))
              .toList(),
        );
        // return InputField(
        //   label: label,
        //   keyboardType: keyboardType,
        //   initialText: BlocProvider.of<SmartFormCubit>(context).getValue(name),
        //   onChange: (s) => BlocProvider.of<SmartFormCubit>(context).changeValue(name: name, value: s),
        //   errorText: error,
        //   obscureText: obscureText,
        //   maxLines: maxLines,
        //   enabled: isEnabled,
        //   lineColor: lineColor,
        // );
      },
      validator: validator == null ? null : (value) => validator?.call(value),
      initialValue: initialValue,
    );
  }
}
