import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledColorPickerPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final bool canBeNone;
  final List<Color>? allowedColors;

  const StyledColorPickerPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
    this.canBeNone = false,
    this.allowedColors,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<int?>(
      fieldName: fieldName,
      builder: (context, field, color, error) {
        return StyledColorPicker(
          value: color?.mapIfNonNull((value) => Color(value)),
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          errorText: error?.toString(),
          onChanged: (color) => port[fieldName] = color?.value,
          canBeNone: canBeNone,
          allowedColors: allowedColors,
        );
      },
    );
  }
}
