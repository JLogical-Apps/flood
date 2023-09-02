import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledDateTimeField extends StyleComponent {
  final DateTime? value;
  final Function(DateTime value)? onChanged;

  final bool showDate;
  final bool showTime;

  final Widget? label;
  final String? labelText;

  final String? errorText;

  final String? hintText;

  StyledDateTimeField({
    super.key,
    this.value,
    this.onChanged,
    this.showDate = true,
    this.showTime = true,
    this.label,
    this.labelText,
    this.errorText,
    this.hintText,
  });
}
