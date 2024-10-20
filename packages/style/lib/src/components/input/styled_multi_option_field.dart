import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledMultiOptionField<T> extends StyleComponent {
  final List<T> values;
  final Function(List<T> value)? onChanged;

  final Widget? label;
  final String? labelText;
  final bool showRequiredIndicator;

  final String? errorText;

  final bool enabled;

  final List<T> options;
  final String Function(T value) itemLabelMapper;

  StyledMultiOptionField({
    super.key,
    required this.values,
    this.onChanged,
    this.label,
    this.labelText,
    this.showRequiredIndicator = false,
    this.errorText,
    this.enabled = true,
    required this.options,
    String Function(T value)? itemLabelMapper,
  }) : itemLabelMapper = itemLabelMapper ?? _defaultIemLabelMapper;

  String getLabel(T value) {
    return itemLabelMapper(value);
  }

  void change(List values) {
    onChanged?.call(values.cast<T>());
  }
}

String _defaultIemLabelMapper<T>(T value) {
  return value.toString();
}
