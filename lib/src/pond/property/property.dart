import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class Property<T> {
  final String name;
  T? value;

  Property({required this.name, T? initialValue}) : this.value = initialValue;

  TypeStateSerializer get typeStateSerializer;

  dynamic toStateValue() => value.mapIfNonNull((value) => typeStateSerializer.onSerialize(value));

  void fromStateValue(dynamic stateValue) => value = typeStateSerializer.onDeserialize(stateValue);

  @override
  String toString() => 'Property<$T>{name = $name, value = $value}';
}
