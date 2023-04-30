import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledColorPicker extends StyleComponent {
  final Color? value;
  final Function(Color? value)? onChanged;

  final Widget? label;
  final String? labelText;

  final String? errorText;

  final bool canBeNone;
  final List<Color>? allowedColors;

  StyledColorPicker({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.errorText,
    this.canBeNone = false,
    this.allowedColors,
  });
}
