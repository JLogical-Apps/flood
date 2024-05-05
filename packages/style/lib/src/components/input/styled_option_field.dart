import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_component.dart';

class StyledOptionField<T> extends StyleComponent {
  final T value;
  final Function(T value)? onChanged;

  final Widget? label;
  final String? labelText;
  final bool showRequiredIndicator;

  final String? errorText;

  final bool enabled;

  final List<T> options;
  final Widget Function(T value) widgetMapper;

  StyledOptionField({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.showRequiredIndicator = false,
    this.errorText,
    this.enabled = true,
    required this.options,
    Widget Function(T value)? widgetMapper,
  }) : widgetMapper = widgetMapper ?? _defaultMapper;

  Widget getOptionChild(T value) {
    return widgetMapper(value);
  }

  void change(T value) {
    onChanged?.call(value);
  }
}

Widget _defaultMapper<T>(T value) {
  return StyledText.body(value.toString());
}
