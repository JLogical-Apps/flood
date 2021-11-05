import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/format.dart';

class StringTypeStateSerializer extends TypeStateSerializer<String> {
  @override
  String onDeserialize(value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }

    if (value is num) {
      return value.formatIntOrDouble();
    }

    return value.toString();
  }

  @override
  onSerialize(String value) {
    return value;
  }
}
