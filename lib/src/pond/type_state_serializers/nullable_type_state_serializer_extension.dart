import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

extension NullableTypeStateSerializerExtension<T> on TypeStateSerializer<T> {
  TypeStateSerializer<T?> asNullable() {
    return NullableTypeStateSerializer<T>(this);
  }
}
