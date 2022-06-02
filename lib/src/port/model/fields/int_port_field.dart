import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../port_field.dart';

class IntPortField extends PortField<int?> {
  IntPortField({required super.name, super.initialValue});

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

      IsIntValidator().validateSync(rawValue);
      return rawValue.tryParseIntAfterClean()!;
    }

    throw Exception('Unknown type to parse whole number from.');
  }
}
