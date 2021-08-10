import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// A radio button that is connected to a radio group.
class SmartRadioOptionField<T> extends SmartFormField<bool> {
  /// The value to assign to the group when this is selected.
  final T radioValue;

  /// The name of the radio group this radio button belongs to.
  final String group;

  /// The label to show after the radio button.
  final Widget label;

  const SmartRadioOptionField({
    Key? key,
    String? name,
    required this.radioValue,
    required this.group,
    required this.label,
    List<Validation<bool>>? validators,
    bool enabled: true,
  }) : super(
          key: key,
          name: name ?? "$group-$radioValue",
          initialValue: false,
          enabled: enabled,
          validators: validators ?? const [],
        );

  @override
  Widget buildForm(
      BuildContext context, bool value, String? error, bool enabled, SmartFormController smartFormController) {
    _updateValue(smartFormController, value);
    final inError = error != null || smartFormController.getError(group) != null;

    return Column(
      children: [
        GestureDetector(
          onTap: () => smartFormController.setData(name: group, value: radioValue),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<T?>(
                  groupValue: smartFormController.getData(group),
                  value: radioValue,
                  onChanged: (value) => smartFormController.setData(name: group, value: value),
                  fillColor: MaterialStateProperty.all(inError ? Colors.red : Theme.of(context).accentColor),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.button!,
                  child: label,
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Text(
            error,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  /// Updates the value of the radio button based on the group's current value.
  void _updateValue(SmartFormController smartFormController, bool value) {
    final groupData = smartFormController.getData(group);
    final isSelected = groupData == radioValue;
    final valueChanged = isSelected != value;
    if (valueChanged) {
      smartFormController.setData(name: name, value: isSelected);
    }
  }
}
