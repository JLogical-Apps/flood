import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class PlaceholderValueObjectProperty<G, S> with IsValueObjectPropertyWrapper<G, S> {
  @override
  final ValueObjectProperty<G, S> property;

  final G Function() placeholder;

  PlaceholderValueObjectProperty({required this.property, required this.placeholder});

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  G get value => property.value ?? placeholder();

  @override
  set(S value) => property.set(value);
}
