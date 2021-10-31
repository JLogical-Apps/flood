import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

mixin WithImplicitTypeSerializer<T> on TypeStateSerializer<T> {
  dynamic onSerialize(T value) => value;

  T onDeserialize(dynamic value) => value;
}