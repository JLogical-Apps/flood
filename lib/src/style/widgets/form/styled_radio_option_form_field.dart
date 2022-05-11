import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../../../form/export_core.dart';
import '../input/styled_radio.dart';

class StyledRadioOptionFormField<T> extends FormFieldModelWidget<BoolFormField, bool> {
  final String? labelText;

  final Widget? label;

  /// The value this option will set when selected.
  final T radioValue;

  StyledRadioOptionFormField({
    Key? key,
    required String groupName,
    this.labelText,
    this.label,
    required this.radioValue,
  }) : super(
          key: key,
          name: groupName,
        );

  @override
  Widget buildField(BuildContext context, BoolFormField field, bool value) {
    _updateValue(context, value);
    return StyledRadio<T?>(
      groupValue: value ? this.radioValue : null,
      radioValue: radioValue,
      label: label,
      onChanged: (value) => getFormModel(context)[name] = value,
    );
  }

  /// Updates the value of the radio button based on the group's current value.
  void _updateValue(BuildContext context, bool value) {
    final groupData = getFormModel(context);
    final isSelected = groupData == this.radioValue;
    final valueChanged = isSelected != value;
    if (valueChanged) {
      setValue(context, isSelected);
    }
  }
}
