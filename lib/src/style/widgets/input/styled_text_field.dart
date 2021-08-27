import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledTextField extends StyledWidget {
  final String? label;
  final Widget? leading;
  final Widget? trailing;

  final String? initialValue;
  final String? errorText;

  final void Function(String value)? onChanged;
  final void Function()? onTap;

  StyledTextField({
    this.label,
    this.leading,
    this.trailing,
    this.initialValue,
    this.errorText,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.textField(context, styleContext, this);
  }
}
