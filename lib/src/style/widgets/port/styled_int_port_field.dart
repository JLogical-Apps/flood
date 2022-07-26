import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledIntPortField extends PortFieldWidget<IntPortField, int?, String>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  /// The suggested value to show if no input is typed in.
  /// Sets this as the value of the FormField if no input has been typed in.
  final String? suggestedValue;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledIntPortField({
    super.key,
    required super.name,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.suggestedValue,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  });

  @override
  String getInitialRawValue(int? portValue) {
    return portValue?.formatIntOrDouble() ?? '';
  }

  @override
  Widget buildField(BuildContext context, IntPortField field, dynamic value, Object? exception) {
    value = value as String;
    return StyledTextField(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      keyboardType: TextInputType.numberWithOptions(signed: true),
      initialText: value,
      hintText: field.fallback ?? suggestedValue,
      onChanged: (text) => setValue(context, text),
      enabled: enabled,
    );
  }
}
