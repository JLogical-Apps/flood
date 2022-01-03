import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class DoubleTypeStateSerializer extends TypeStateSerializer<double> {
  DoubleTypeStateSerializer();

  @override
  double deserialize(value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    if (value is num) {
      return value.toDouble();
    } else {
      return double.parse(value.toString());
    }
  }

  @override
  serialize(double value) {
    return value;
  }
}
