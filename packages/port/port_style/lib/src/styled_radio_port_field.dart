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

  final List<T> options;
  final String Function(T value) stringMapper;

  const StyledRadioPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
    required this.options,
    String Function(T value)? stringMapper,
  }) : stringMapper = stringMapper ?? _defaultMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<T>(
      fieldName: fieldName,
      builder: (context, field, value, error) {
        return StyledRadioField<T>(
          value: value,
          labelText: labelText,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (value) => port[fieldName] = value,
          options: options,
          stringMapper: stringMapper,
        );
      },
    );
  }
}

String _defaultMapper<T>(T value) {
  return value.toString();
}
