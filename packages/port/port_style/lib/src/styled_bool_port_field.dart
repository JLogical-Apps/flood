import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledBoolFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  const StyledBoolFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<bool?>(
      fieldName: fieldName,
      builder: (context, field, value, error) {
        return StyledCheckbox(
          value: value ?? false,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          errorText: error?.toString(),
          onChanged: enabled
              ? (value) {
                  port.clearError(name: fieldName);
                  port[fieldName] = value;
                }
              : null,
        );
      },
    );
  }
}
