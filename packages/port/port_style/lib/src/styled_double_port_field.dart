import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledDoubleFieldPortField extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final String? hintText;

  final bool enabled;

  const StyledDoubleFieldPortField({
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
    return PortFieldBuilder<double?>(
      fieldPath: fieldPath,
      builder: (context, field, amount, error) {
        return StyledTextField(
          text: amount?.formatIntOrDouble() ?? '',
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          hintText: hintText,
          errorText: error?.toString(),
          enabled: enabled,
          keyboard: TextInputType.numberWithOptions(decimal: true),
          onChanged: (amountRaw) {
            if (amountRaw.isEmpty) {
              port.clearError(path: fieldPath);
              port[fieldPath] = null;
              return;
            }

            final amount = amountRaw.tryParseDoubleAfterClean(cleanCurrency: false);
            if (amount == null) {
              port.setError(path: fieldPath, error: 'Must be a number!');
              return;
            }

            port.clearError(path: fieldPath);
            port[fieldPath] = amount;
          },
        );
      },
    );
  }
}
