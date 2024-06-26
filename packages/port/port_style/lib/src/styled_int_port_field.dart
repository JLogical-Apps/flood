import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledIntFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final String? hintText;

  final bool enabled;

  const StyledIntFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<int?>(
      fieldName: fieldName,
      builder: (context, field, amount, error) {
        return StyledTextField(
          text: amount?.formatIntOrDouble() ?? '',
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          hintText: hintText,
          errorText: error?.toString(),
          enabled: enabled,
          keyboard: TextInputType.number,
          onChanged: (amountRaw) {
            if (amountRaw.isEmpty) {
              port.clearError(name: fieldName);
              port[fieldName] = null;
              return;
            }

            final amount = amountRaw.tryParseIntAfterClean(cleanCurrency: false);
            if (amount == null) {
              port.setError(name: fieldName, error: 'Must be an integer!');
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
