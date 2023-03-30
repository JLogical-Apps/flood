import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledDoubleFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  const StyledDoubleFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<double?>(
      fieldName: fieldName,
      builder: (context, field, amount, error) {
        return StyledTextField(
          text: amount?.formatIntOrDouble() ?? '',
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (amountRaw) {
            if (amountRaw.isEmpty) {
              port.clearError(name: fieldName);
              port[fieldName] = null;
              return;
            }

            final amount = amountRaw.tryParseDoubleAfterClean(cleanCurrency: false);
            if (amount == null) {
              port.setError(name: fieldName, error: 'Must be a number!');
              return;
            }

            port.clearError(name: fieldName);
            port[fieldName] = amount;
          },
        );
      },
    );
  }
}
