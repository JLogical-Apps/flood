import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Styled SmartRadioOptionField that uses a [StyledRadio].
/// This should be used in conjunction with [SmartRadioGroup].
class StyledSmartRadioOptionField<T> extends SmartFormField<bool> {
  /// The value to assign to the group when this is selected.
  final T radioValue;

  /// The name of the radio group this radio button belongs to.
  final String group;

  /// The label to show after the radio button.
  final String label;

  const StyledSmartRadioOptionField({
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
    return StyledRadio<T?>(
      groupValue: value ? radioValue : null,
      radioValue: radioValue,
      label: label,
      onChanged: (value) => smartFormController.setData(name: group, value: value),
      errorText: error,
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
