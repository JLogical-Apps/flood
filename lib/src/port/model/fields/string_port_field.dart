import 'package:jlogical_utils/src/utils/export_core.dart';

import '../port_field.dart';

class StringPortField extends PortField<String?> {
  StringPortField({required super.name, super.initialValue});

  @override
  String? valueParser(dynamic rawValue) {
    String? value = rawValue?.toString();
    if (value?.isBlank == true) {
      value = null;
    }

    return value;
  }
}
