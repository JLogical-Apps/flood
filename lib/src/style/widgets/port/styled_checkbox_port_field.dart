import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_checkbox.dart';

class StyledCheckboxPortField extends PortFieldWidget<BoolPortField, bool, bool>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledCheckboxPortField({
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
  Widget buildField(BuildContext context, BoolPortField field, bool value, Object? exception) {
    return StyledCheckbox(
      value: value,
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      onChanged: (value) {
        setValue(context, value);
      },
    );
  }
}
