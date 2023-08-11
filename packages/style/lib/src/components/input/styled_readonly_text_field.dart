import 'package:flutter/material.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/style_component.dart';

class StyledReadonlyTextField extends StatelessWidget {
  final String? text;

  final Widget? label;
  final String? labelText;
  final String? errorText;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool obscureText;

  final int? maxLines;

  final Function()? onTapped;

  StyledReadonlyTextField({
    super.key,
    this.text,
    this.label,
    this.labelText,
    this.errorText,
    this.hintText,
    this.leading,
    this.leadingIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      key: ValueKey(text),
      text: text,
      label: label,
      labelText: labelText,
      errorText: errorText,
      hintText: hintText,
      leading: leading,
      leadingIcon: leadingIcon,
      obscureText: obscureText,
      maxLines: maxLines,
      onTapped: onTapped,
    );
  }
}
