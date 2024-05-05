import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledTextField extends StyleComponent {
  final String? text;
  final Function(String value)? onChanged;

  final Widget? label;
  final String? labelText;
  final bool showRequiredIndicator;
  final String? errorText;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool enabled;
  final bool readonly;

  final bool obscureText;

  final int? maxLines;
  final TextInputType? keyboard;

  final Function()? onTapped;
  final Function(String text)? onSubmitted;

  StyledTextField({
    super.key,
    this.text,
    this.onChanged,
    this.label,
    this.labelText,
    this.showRequiredIndicator = false,
    this.errorText,
    this.hintText,
    this.leading,
    this.leadingIcon,
    this.enabled = true,
    this.readonly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboard,
    this.onTapped,
    this.onSubmitted,
  });
}
