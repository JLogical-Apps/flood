import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledCheckbox extends StyledWidget {
  final String? labelText;
  final Widget? label;

  final bool value;

  /// If not null, then the error associated with this checkbox.
  final String? errorText;

  /// Action to perform when the checkbox is tapped.
  final void Function(bool value)? onChanged;

  bool get hasError => errorText != null;

  StyledCheckbox({
    this.labelText,
    this.label,
    required this.value,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.checkbox(context, styleContext, this);
  }
}
