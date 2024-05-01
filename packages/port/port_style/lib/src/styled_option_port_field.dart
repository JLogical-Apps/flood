import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledOptionPortField<T> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final Widget Function(T value) widgetMapper;

  const StyledOptionPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
    Widget Function(T value)? widgetMapper,
  }) : widgetMapper = widgetMapper ?? _defaultMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<T>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        final options =
            field.findOptionsOrNull() ?? (throw Exception('Could not find options for port field [$field]'));
        return StyledOptionField<T>(
          value: value,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (value) => port[fieldPath] = value,
          options: options.cast<T>(),
          widgetMapper: widgetMapper,
        );
      },
    );
  }
}

Widget _defaultMapper<T>(T value) {
  return StyledText.body(value.toString());
}
