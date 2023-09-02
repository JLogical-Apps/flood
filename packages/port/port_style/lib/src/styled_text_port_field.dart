import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledTextFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool enabled;

  final bool obscureText;

  final int? maxLines;

  const StyledTextFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.hintText,
    this.leadingIcon,
    this.leading,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<String?>(
      fieldName: fieldName,
      builder: (context, field, text, error) {
        return StyledTextField(
          text: text ?? '',
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull(port)) : null,
          label: label,
          errorText: error?.toString(),
          hintText: hintText,
          enabled: enabled,
          obscureText: obscureText,
          onChanged: (text) => port[fieldName] = text,
          maxLines: maxLines ?? (field.findIsMultiline() ? 3 : null),
        );
      },
    );
  }
}
