import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledDateTimeFieldPortField extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final String? hintText;

  final bool enabled;

  const StyledDateTimeFieldPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<DateTime?>(
      fieldPath: fieldPath,
      builder: (context, field, text, error) {
        return StyledDateTimeField(
          value: text,
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          errorText: error?.toString(),
          hintText: hintText,
          showTime: field.findDateFieldOrNull()?.isTime ?? false,
          onChanged: (text) => port[fieldPath] = text,
        );
      },
    );
  }
}
