import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class NullableTypeStateSerializer<T> extends TypeStateSerializer<T?> {
  final TypeStateSerializer<T> typeStateSerializer;

  NullableTypeStateSerializer(this.typeStateSerializer);

  @override
  serialize(T? value) {
    return value == null ? null : typeStateSerializer.serialize(value);
  }

  @override
  T? deserialize(value) {
    return value == null ? null : typeStateSerializer.deserialize(value);
  }

  @override
  bool matchesSerializing(value) {
    return value == null || typeStateSerializer.matchesSerializing(value);
  }

  @override
  bool matchesDeserializing(value) {
    return value == null || typeStateSerializer.matchesDeserializing(value);
  }
}
