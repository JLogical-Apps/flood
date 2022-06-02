import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_radio.dart';

class StyledRadioOptionPortField<T> extends PortFieldWidget<OptionsPortField<T>, T?, T?> with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  /// The value this option will set when selected.
  final T radioValue;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledRadioOptionPortField({
    Key? key,
    required String groupName,
    this.labelText,
    this.label,
    required this.radioValue,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: groupName,
        );

  @override
  Widget buildField(BuildContext context, OptionsPortField<T> field, T? value, Object? exception) {
    return StyledRadio<T?>(
      label: label,
      labelText: labelText,
      errorText: getExceptionText(exception),
      groupValue: value,
      radioValue: radioValue,
      onChanged: (value) => getPort(context)[name] = value,
    );
  }
}
