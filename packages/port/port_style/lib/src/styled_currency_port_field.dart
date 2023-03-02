import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledCurrencyFieldPortField extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  const StyledCurrencyFieldPortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<int?>(
      fieldName: fieldName,
      builder: (context, amountCents, error) {
        return StyledTextField(
          text: amountCents?.formatCentsAsCurrency() ?? '',
          labelText: labelText,
          label: label,
          errorText: error?.toString(),
          enabled: enabled,
          onChanged: (amountRaw) {
            final cents = amountRaw.tryParseDoubleAfterClean()?.mapIfNonNull((amount) => (amount * 100).round());
            if (cents == null) {
              port.setError(name: fieldName, error: 'Must be a currency!');
              return;
            }

            port.clearError(name: fieldName);
            port[fieldName] = cents;
          },
        );
      },
    );
  }
}
