import '../context/app_context.dart';
import 'type_state_serializer.dart';

/// Given a [value], it serializes/deserializes the value based off its runtime type.
class DynamicTypeStateSerializer extends TypeStateSerializer<dynamic> {
  @override
  serialize(value) {
    return AppContext.global.getTypeStateSerializerBySerializeValue(value).serialize(value);
  }

  @override
  deserialize(value) {
    return AppContext.global.getTypeStateSerializerByDeserializeValue(value).deserialize(value);
  }
}
