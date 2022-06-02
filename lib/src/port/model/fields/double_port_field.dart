import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../patterns/export_core.dart';
import '../port_field.dart';

class DoublePortField extends PortField<double?> {
  DoublePortField({required super.name, super.initialValue});

  @override
  double? valueParser(dynamic rawValue) {
    if (rawValue == null) {
      return null;
    }

    if (rawValue is num) {
      return rawValue.toDouble();
    }

    if (rawValue is String) {
      if(rawValue.isBlank) {
        return null;
      }

      IsDoubleValidator().validateSync(rawValue);
      return rawValue.tryParseDoubleAfterClean(cleanCurrency: false, cleanCommas: true)!;
    }

    throw Exception('Unknown type to parse number from.');
  }
}
