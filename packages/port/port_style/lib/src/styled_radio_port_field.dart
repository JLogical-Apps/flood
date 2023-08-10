import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledRadioPortField<T> extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final String Function(T value) stringMapper;

  const StyledRadioPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
    String Function(T value)? stringMapper,
  }) : stringMapper = stringMapper ?? _defaultMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<T>(
      fieldName: fieldName,
      builder: (context, field, value, error) {
        final options =
            field.findOptionsOrNull() ?? (throw Exception('Could not find options for port field [$field]'));
        return StyledRadioField<T>(
          value: value,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull(port)) : null,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (value) => port[fieldName] = value,
          options: options.cast<T>(),
          stringMapper: stringMapper,
        );
      },
    );
  }
}

String _defaultMapper<T>(T value) {
  return value.toString();
}
