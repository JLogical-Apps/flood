import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class DateTimeTypeStateSerializer extends TypeStateSerializer<DateTime> {
  @override
  DateTime deserialize(value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }

    throw Exception('Cannot deserialize DateTime from $value');
  }

  @override
  serialize(DateTime value) {
    return value.toUtc().millisecondsSinceEpoch;
  }
}
