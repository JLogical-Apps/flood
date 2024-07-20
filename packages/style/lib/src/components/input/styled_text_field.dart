import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:style/src/style_component.dart';

class StyledTextField extends StyleComponent {
  final String? text;
  final Function(String value)? onChanged;
  final bool Function(String textControllerText, String value)? shouldUpdate;

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
  final TextInputAction? action;
  final List<TextInputFormatter>? inputFormatters;

  final Function()? onTapped;
  final Function(String text)? onSubmitted;

  StyledTextField({
    super.key,
    this.text,
    this.onChanged,
    this.shouldUpdate,
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
    this.action,
    this.inputFormatters,
    this.onTapped,
    this.onSubmitted,
  });
}
