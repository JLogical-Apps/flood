import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_text_field.dart';

class StyledTextPortField extends PortFieldWidget<StringPortField, String?, String>
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

  final TextInputType keyboardType;

  final TextCapitalization textCapitalization;

  final bool obscureText;

  /// The maximum length of characters in the field. If null, no limit is enforced.
  final int? maxLength;

  /// The number of lines to show.
  final int maxLines;

  final bool enabled;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  @override
  String getInitialRawValue(String? portValue) {
    return portValue?.toString() ?? '';
  }

  StyledTextPortField({
    super.key,
    required super.name,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.suggestedValue,
    this.keyboardType: TextInputType.text,
    this.textCapitalization: TextCapitalization.sentences,
    this.obscureText: false,
    this.maxLength,
    this.maxLines: 1,
    this.enabled: true,
    this.exceptionTextGetterOverride,
  });

  @override
  Widget buildField(BuildContext context, StringPortField field, String? value, Object? exception) {
    return StyledTextField(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      keyboardType: keyboardType,
      initialText: value,
      hintText: field.fallback ?? suggestedValue,
      onChanged: (text) => setValue(context, text),
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      enabled: enabled,
    );
  }
}
