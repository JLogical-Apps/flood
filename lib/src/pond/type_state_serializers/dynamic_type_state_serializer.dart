import '../context/app_context.dart';
import 'type_state_serializer.dart';

/// Given a [value], it serializes/deserializes the value based off its runtime type.
class DynamicTypeStateSerializer extends TypeStateSerializer<dynamic> {
  @override
  serialize(value) {
    final serializer = AppContext.global.getTypeStateSerializerBySerializeValue(value);
    if (serializer is DynamicTypeStateSerializer) {
      return value;
    }
    return serializer.serialize(value);
  }

  @override
  deserialize(value) {
    final serializer = AppContext.global.getTypeStateSerializerByDeserializeValue(value);
    if (serializer is DynamicTypeStateSerializer) {
      return value;
    }
    return serializer.deserialize(value);
  }
}
