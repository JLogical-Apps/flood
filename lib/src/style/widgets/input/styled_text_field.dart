import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledTextField extends StyledWidget {
  final String? labelText;
  final Widget? label;

  final Widget? leading;
  final Widget? trailing;

  final String? initialText;
  final String? hintText;
  final String? errorText;

  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final bool obscureText;
  final int? maxLength;
  final int maxLines;
  final bool enabled;

  final void Function(String value)? onChanged;
  final void Function()? onTap;

  StyledTextField({
    Key? key,
    this.labelText,
    this.label,
    this.leading,
    this.trailing,
    this.initialText,
    this.hintText,
    this.errorText,
    this.backgroundColor,
    this.keyboardType,
    this.textCapitalization,
    this.obscureText: false,
    this.maxLength,
    this.maxLines: 1,
    this.enabled: true,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.textField(context, styleContext, this);
  }
}
