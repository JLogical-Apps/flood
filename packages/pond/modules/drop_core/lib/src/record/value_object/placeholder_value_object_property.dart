import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class PlaceholderValueObjectProperty<G, S>
    with IsValueObjectPropertyWrapper<G, S, PlaceholderValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final G Function() placeholder;

  PlaceholderValueObjectProperty({required this.property, required this.placeholder});

  @override
  State modifyState(State state) {
    if (property.value == null) {
      return state.withData(state.data.copy()..set(property.name, placeholder()));
    }
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  G get value => property.value ?? placeholder();

  @override
  G? get valueOrNull => property.valueOrNull ?? guard(() => placeholder());

  @override
  set(S value) => property.set(value);

  @override
  PlaceholderValueObjectProperty<G, S> copy() {
    return PlaceholderValueObjectProperty<G, S>(property: property.copy(), placeholder: placeholder);
  }
}
