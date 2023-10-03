import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../patterns/export_core.dart';
import '../port_field.dart';

class CurrencyPortField extends PortField<int?> {
  CurrencyPortField({required super.name, super.initialValue, super.initialFallback});

  @override
  int? valueParser(dynamic rawValue) {
    if (rawValue == null) {
      return null;
    }

    if (rawValue is int) {
      return rawValue;
    }

    if (rawValue is num) {
      return rawValue.floor();
    }

    if (rawValue is String) {
      if(rawValue.isBlank) {
        return null;
      }

      IsCurrencyValidator().validateSync(rawValue);
      final dollars = rawValue.tryParseDoubleAfterClean(cleanCommas: true, cleanCurrency: true)!;
      final cents = (dollars * 100).round();
      return cents;
    }

    throw ValidationException(failedValue: 'Unknown type to parse currency from.');
  }
}