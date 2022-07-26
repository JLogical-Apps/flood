import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_color_picker.dart';

class StyledColorPortField extends PortFieldWidget<IntPortField, int?, int?>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  final List<Color>? allowedColors;

  final bool canBeNone;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledColorPortField({
    super.key,
    required String name,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.allowedColors,
    this.canBeNone: false,
    this.exceptionTextGetterOverride,
  }) : super(name: name);

  @override
  Widget buildField(BuildContext context, IntPortField field, int? value, Object? exception) {
    return StyledColorPicker(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      color: value.mapIfNonNull((value) => Color(value)),
      onChanged: (color) => setValue(context, color?.value),
      allowedColors: allowedColors,
      canBeNone: canBeNone,
    );
  }
}
