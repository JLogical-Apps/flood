import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_dropdown.dart';

class StyledOptionsPortField<T> extends PortFieldWidget<OptionsPortField<T>, T?, T?>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  final Widget Function(T? value)? builder;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledOptionsPortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.builder,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, OptionsPortField<T> field, T? value, Object? exception) {
    return StyledDropdown<T>(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      value: value,
      onChanged: (value) => setValue(context, value),
      options: field.options,
      canBeNone: field.canBeNone,
      builder: builder,
    );
  }
}
