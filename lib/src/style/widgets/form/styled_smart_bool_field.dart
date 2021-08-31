import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Styled SmartBoolField that uses a [StyledCheckbox].
class StyledSmartBoolField extends SmartFormField<bool> {
  /// The label for the field.
  final String label;

  const StyledSmartBoolField({
    Key? key,
    required String name,
    required this.label,
    bool initiallyChecked: false,
    List<Validation<bool>>? validators,
    bool enabled: true,
  }) : super(
          key: key,
          name: name,
          initialValue: initiallyChecked,
          validators: validators ?? const [],
          enabled: enabled,
        );

  @override
  Widget buildForm(
      BuildContext context, bool value, String? error, bool enabled, SmartFormController smartFormController) {
    return StyledCheckbox(
      value: value,
      label: label,
      errorText: error,
      onChanged: (value) => smartFormController.setData(name: name, value: value),
    );
  }
}
