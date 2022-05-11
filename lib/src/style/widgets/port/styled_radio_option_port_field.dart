import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_radio.dart';

class StyledRadioOptionPortField<T> extends PortFieldWidget<BoolPortField, bool> {
  final String? labelText;

  final Widget? label;

  /// The value this option will set when selected.
  final T radioValue;

  StyledRadioOptionPortField({
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
  Widget buildField(BuildContext context, BoolPortField field, bool value) {
    _updateValue(context, value);
    return StyledRadio<T?>(
      groupValue: value ? this.radioValue : null,
      radioValue: radioValue,
      label: label,
      onChanged: (value) => getPort(context)[name] = value,
    );
  }

  /// Updates the value of the radio button based on the group's current value.
  void _updateValue(BuildContext context, bool value) {
    final port = getPort(context);
    final isSelected = port[name] == this.radioValue;
    final valueChanged = isSelected != value;
    if (valueChanged) {
      setValue(context, isSelected);
    }
  }
}
