import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../input/styled_radio.dart';

class StyledRadioOptionPortField<T> extends PortFieldWidget<OptionsPortField<T>, T?, T?>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  /// The value this option will set when selected.
  final T radioValue;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledRadioOptionPortField({
    Key? key,
    required String groupName,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    required this.radioValue,
    this.exceptionTextGetterOverride,
  }) : super(
          key: key,
          name: groupName,
        );

  @override
  Widget buildField(BuildContext context, OptionsPortField<T> field, T? value, Object? exception) {
    return StyledRadio<T?>(
      label: getRequiredLabel(context, field: field),
      errorText: getExceptionText(exception),
      groupValue: value,
      radioValue: radioValue,
      onChanged: (value) => getPort(context)[name] = value,
    );
  }
}
