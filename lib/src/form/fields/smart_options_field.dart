import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// SmartField that handles a list of options.
class SmartOptionsField<T> extends SmartFormField<T?> {
  /// The options to choose from.
  final List<T> options;

  /// Builder for an option to a widget.
  /// Also must handle the null option if no selection.
  /// Defaults to a Text with the value.toString().
  final Widget Function(T?)? builder;

  /// An optional label for the field.
  final String? label;

  const SmartOptionsField({
    Key? key,
    required String name,
    required this.options,
    T? initialValue,
    this.builder,
    this.label,
    List<Validation<T?>>? validators,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue,
          validators: validators ?? const [],
        );

  @override
  Widget buildForm(BuildContext context, T? value, String? error, SmartFormController smartFormController) {
    var _builder = builder ?? (item) => Text(item?.toString() ?? 'None');
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: error == null ? Colors.black : Colors.red, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label!,
                style: Theme.of(context).textTheme.button,
                textAlign: TextAlign.left,
              ),
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
              onChanged: (value) => smartFormController.setData(name: name, value: value),
            ),
          ),
        ],
      ),
    );
  }
}