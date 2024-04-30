import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class MapValueObjectProperty<K, V> with IsValueObjectProperty<Map<K, V>, Map<K, V>, MapValueObjectProperty<K, V>> {
  final FieldValueObjectProperty<K> property;

  @override
  Map<K, V> value;

  final Type mapType;

  MapValueObjectProperty({required this.property, Map<K, V>? value})
      : value = value ?? {},
        mapType = Map<K, V>;

  @override
  Type get getterType => mapType;

  @override
  Type get setterType => mapType;

  @override
  String get name => property.name;

  @override
  set(Map<K, V>? value) => this.value = value ?? {};

  @override
  void fromState(State state) {
    value = (state[name] as Map?)?.cast<K, V>() ?? {};
  }

  @override
  State modifyState(State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  MapValueObjectProperty<K, V> copy() {
    return MapValueObjectProperty<K, V>(property: property.copy());
  }
}
