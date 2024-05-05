import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledBoolFieldPortField extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  const StyledBoolFieldPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<bool?>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        return StyledCheckbox(
          value: value ?? false,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          showRequiredIndicator: field.findIsRequired(),
          errorText: error?.toString(),
          onChanged: enabled
              ? (value) {
                  port.clearError(path: fieldPath);
                  port[fieldPath] = value;
                }
              : null,
        );
      },
    );
  }
}
