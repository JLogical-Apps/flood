import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledCheckbox extends StyleComponent {
  final bool value;
  final Function(bool value)? onChanged;

  final Widget? label;
  final String? labelText;
  final bool showRequiredIndicator;
  final String? errorText;

  final Widget? leading;
  final IconData? leadingIcon;

  StyledCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.showRequiredIndicator = false,
    this.errorText,
    this.leading,
    this.leadingIcon,
  });
}
