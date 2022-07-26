import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_date_field.dart';

class StyledDatePortField extends PortFieldWidget<DatePortField, DateTime?, DateTime?>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledDatePortField({
    Key? key,
    required String name,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: name,
        );

  @override
  DateTime? getInitialRawValue(DateTime? portValue) {
    return portValue ?? DateTime.now();
  }

  @override
  Widget buildField(BuildContext context, DatePortField field, DateTime? value, Object? exception) {
    return StyledDateField(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      date: value,
      onChanged: (value) => setValue(context, value),
    );
  }
}
