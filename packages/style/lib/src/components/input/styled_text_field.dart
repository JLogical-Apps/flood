import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledTextField extends StyleComponent {
  final String? text;
  final Function(String)? onChanged;

  final Widget? label;
  final String? labelText;

  final String? errorText;

  final bool enabled;

  StyledTextField({
    this.text,
    this.onChanged,
    this.label,
    this.labelText,
    this.errorText,
    this.enabled = true,
  });
}
