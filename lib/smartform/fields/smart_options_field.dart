import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/fields/smart_field.dart';

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
    var _builder = builder ?? (item) => Text(item?.toString() ?? 'None');
    return SmartField<T?>(
      name: name,
      builder: (value, error) {
        return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: error == null ? Colors.black : Colors.red, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (label != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(label!, style: Theme.of(context).textTheme.button, textAlign: TextAlign.left,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<T?>(
                  value: value,
                  hint: Text('Select an option'),
                  decoration: InputDecoration(
                    errorText: error,
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  items: (<T?>[null] + options)
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: _builder(value),
                          ))
                      .toList(),
                  onChanged: (value) => BlocProvider.of<SmartFormCubit>(context).changeValue(name: name, value: value),
                ),
              ),
            ],
          ),
        );
      },
      validator: validator == null ? null : (value) => validator?.call(value),
      initialValue: initialValue,
    );
  }
}
