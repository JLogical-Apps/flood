import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledOptionPortField<T> extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final List<T> options;
  final Widget Function(T value) widgetMapper;

  const StyledOptionPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
    required this.options,
    Widget Function(T value)? widgetMapper,
  }) : widgetMapper = widgetMapper ?? _defaultMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<T>(
      fieldName: fieldName,
      builder: (context, field, value, error) {
        return StyledOptionField<T>(
          value: value,
          labelText: labelText,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (value) => port[fieldName] = value,
          options: options,
          widgetMapper: widgetMapper,
        );
      },
    );
  }
}

Widget _defaultMapper<T>(T value) {
  return StyledText.button(value.toString());
}
