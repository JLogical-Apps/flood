import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_checkbox.dart';

/// Styled SmartBoolField that uses a [StyledCheckbox].
class StyledSmartBoolField extends SmartFormField<bool> {
  final String? labelText;

  final Widget? label;

  const StyledSmartBoolField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
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
      labelText: labelText,
      label: label,
      errorText: error,
      onChanged: (value) => smartFormController.setData(name: name, value: value),
    );
  }
}
