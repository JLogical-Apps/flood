import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledTextFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  const StyledTextFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<String?>(
      fieldName: fieldName,
      builder: (context, text, error) {
        return StyledTextField(
          text: text ?? '',
          labelText: labelText,
          label: label,
          errorText: error?.toString(),
          onChanged: (text) => port[fieldName] = text,
        );
      },
    );
  }
}
