import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_color_picker.dart';

class StyledColorPortField extends PortFieldWidget<IntPortField, int?> with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  final List<Color>? allowedColors;

  final bool canBeNone;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledColorPortField({
    super.key,
    required String name,
    this.labelText,
    this.label,
    this.allowedColors,
    this.canBeNone: false,
    this.exceptionTextGetterOverride,
  }) : super(name: name);

  @override
  Widget buildField(BuildContext context, IntPortField field, int? value, Object? exception) {
    return StyledColorPicker(
      label: label,
      labelText: labelText,
      errorText: getExceptionText(exception),
      color: value.mapIfNonNull((value) => Color(value)),
      onChanged: (color) => setValue(context, color?.value),
      allowedColors: allowedColors,
      canBeNone: canBeNone,
    );
  }
}
