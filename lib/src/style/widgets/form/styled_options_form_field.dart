import 'package:flutter/material.dart';

import '../../../form/export.dart';
import '../input/styled_dropdown.dart';

class StyledOptionsFormField<T> extends FormFieldModelWidget<T?> {
  final String? labelText;

  final Widget? label;

  final Widget Function(T? value)? builder;

  StyledOptionsFormField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.builder,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, T? value) {
    return StyledDropdown<T>(
      value: value,
      onChanged: (value) => setValue(context, value),
      label: label,
      options: options,
      canBeNone: canBeNone,
      builder: builder,
    );
  }
}
