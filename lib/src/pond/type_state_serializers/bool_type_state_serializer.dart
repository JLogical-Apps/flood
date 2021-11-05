import 'package:jlogical_utils/src/pond/export.dart';

class BoolTypeStateSerializer extends TypeStateSerializer<bool> {
  @override
  bool onDeserialize(value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value == 'true';
    }

    throw Exception('Cannot deserialize bool from $value');
  }

  @override
  dynamic onSerialize(bool value) {
    return value;
  }
}
