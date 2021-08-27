import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledCheckbox extends StyledWidget {
  final String? label;
  final bool value;

  final String? errorText;

  final void Function(bool value)? onChanged;

  StyledCheckbox({
    this.label,
    required this.value,
    this.errorText,
    this.onChanged,
  });

  bool get hasError => errorText != null;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.checkbox(context, styleContext, this);
  }
}
