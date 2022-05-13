import 'package:flutter/material.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_dropdown.dart';

class StyledOptionsPortField<T> extends PortFieldWidget<OptionsPortField<T>, T?>
    with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  final Widget Function(T? value)? builder;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledOptionsPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.builder,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, OptionsPortField<T> field, T? value, Object? exception) {
    return StyledDropdown<T>(
      labelText: labelText,
      label: label,
      errorText: getExceptionText(exception),
      value: value,
      onChanged: (value) => setValue(context, value),
      options: field.options,
      canBeNone: field.canBeNone,
      builder: builder,
    );
  }
}
