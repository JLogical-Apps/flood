import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class MapValueObjectProperty<K, V, L>
    with IsValueObjectProperty<Map<K, V>, Map<K, V>, L, MapValueObjectProperty<K, V, L>> {
  final FieldValueObjectProperty<K, L> property;

  @override
  Map<K, V> value;

  MapValueObjectProperty({required this.property, Map<K, V>? value}) : value = value ?? {};

  @override
  String get name => property.name;

  @override
  set(Map<K, V>? value) => this.value = value ?? {};

  @override
  void fromState(CoreDropContext context, State state) {
    value = (state[name] as Map?)?.cast<K, V>() ?? {};
  }

  @override
  State modifyState(CoreDropContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  Future<L> load(CoreDropContext context) => property.load(context);

  @override
  MapValueObjectProperty<K, V, L> copy() {
    return MapValueObjectProperty<K, V, L>(property: property.copy());
  }

  @override
  List<Object?> get props => [property, value];
}
