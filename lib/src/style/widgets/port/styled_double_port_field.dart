import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledDoublePortField extends PortFieldWidget<DoublePortField, double?> with WithPortExceptionTextGetter {
  final String? labelText;

  final Widget? label;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final double? suggestedValue;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledDoublePortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.suggestedValue,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  Widget buildField(BuildContext context, DoublePortField field, double? value, Object? exception) {
    return StyledTextField(
      labelText: labelText,
      label: label,
      errorText: getExceptionText(exception),
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      initialText: value?.formatIntOrDouble(),
      hintText: suggestedValue?.formatIntOrDouble(),
      onChanged: (text) {
        if (text.isBlank) {
          setValue(context, null);
          return;
        }

        final parsedDouble = text.tryParseDoubleAfterClean(cleanCommas: true);
        if (parsedDouble == null) {
          return;
        }

        setValue(context, parsedDouble);
      },
      enabled: enabled,
    );
  }
}
