import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/port/export_core.dart';
import 'package:jlogical_utils/src/port/ui/styled_required_indicator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../port/ui/port_field_widget.dart';
import '../text/styled_body_text.dart';

mixin WithRequiredLabelGetter<F extends PortField<T>, T, R> on PortFieldWidget<F, T, R> {
  String? get labelText;

  Widget? get label;

  /// Whether to show the required "*" indicator.
  /// If null, then defaults to whether the field is required.
  bool? get showRequiredIndicator => null;

  Widget getRequiredLabel(
    BuildContext context, {
    required F field,
    Widget labelTextBuilder(String labelText)?,
  }) {
    var widgetLabel = label ??
        labelText?.mapIfNonNull((labelText) => (labelTextBuilder ?? StyledBodyText.new).call(labelText)) ??
        SizedBox.shrink();

    final shouldShowRequiredIndicator = showRequiredIndicator ?? field.isRequired();
    if (shouldShowRequiredIndicator) {
      widgetLabel = StyledRequiredIndicator(child: widgetLabel);
    }

    return widgetLabel;
  }
}
