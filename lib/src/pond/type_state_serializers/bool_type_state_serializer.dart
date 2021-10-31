import 'package:jlogical_utils/src/pond/export.dart';

class BoolTypeStateSerializer extends TypeStateSerializer<bool> {
  @override
  bool? onDeserialize(value) {
    if (value == null) {
      return null;
    } else if (value is bool) {
      return value;
    } else if (value is String) {
      return value == 'true';
    }
  }

  @override
  dynamic onSerialize(bool value) {
    return value;
  }
}
