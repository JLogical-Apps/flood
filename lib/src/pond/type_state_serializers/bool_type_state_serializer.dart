import 'package:jlogical_utils/src/pond/export.dart';

class BoolTypeStateSerializer extends TypeStateSerializer<bool> {
  @override
  bool deserialize(value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value == 'true';
    }

    throw Exception('Cannot deserialize bool from $value');
  }

  @override
  dynamic serialize(bool value) {
    return value;
  }
}
