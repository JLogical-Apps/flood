import 'package:jlogical_utils/src/pond/export.dart';

class NullableTypeStateSerializer<T> extends TypeStateSerializer<T?> {
  final TypeStateSerializer<T> typeStateSerializer;

  NullableTypeStateSerializer(this.typeStateSerializer);

  @override
  onSerialize(T? value) {
    return value == null ? null : typeStateSerializer.onSerialize(value);
  }

  @override
  T? onDeserialize(value) {
    return value == null ? null : typeStateSerializer.onDeserialize(value);
  }
}
