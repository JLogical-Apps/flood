import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledMultiOptionPortField<T> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final String Function(T value) itemLabelMapper;

  const StyledMultiOptionPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
    String Function(T value)? itemLabelMapper,
  }) : itemLabelMapper = itemLabelMapper ?? _defaultItemLabelMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<List<T>>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        final options =
            field.findOptionsOrNull() ?? (throw Exception('Could not find options for port field [$field]'));
        return StyledMultiOptionField<T>(
          values: value,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          showRequiredIndicator: field.findIsRequired(),
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (value) => port[fieldPath] = value,
          options: options.cast<T>(),
          itemLabelMapper: itemLabelMapper,
        );
      },
    );
  }
}

String _defaultItemLabelMapper<T>(T value) {
  return value.toString();
}
