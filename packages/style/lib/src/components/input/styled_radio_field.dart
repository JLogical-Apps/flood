import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledRadioField<T> extends StyleComponent {
  final T value;
  final Function(T value)? onChanged;

  final Widget? label;
  final String? labelText;

  final String? errorText;

  final bool enabled;

  final List<T> options;
  final String Function(T value) stringMapper;

  StyledRadioField({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.errorText,
    this.enabled = true,
    required this.options,
    String Function(T value)? stringMapper,
  }) : stringMapper = stringMapper ?? _defaultMapper;

  String getOptionText(T value) {
    return stringMapper(value);
  }

  void changeValue(T value) {
    onChanged?.call(value);
  }
}

String _defaultMapper<T>(T value) {
  return value.toString();
}
