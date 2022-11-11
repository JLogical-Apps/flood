import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class FallbackValueObjectProperty<T, S> implements ValueObjectProperty<T, S> {
  final ValueObjectProperty<T?, S> property;

  final T Function() fallback;

  FallbackValueObjectProperty({required this.property, required this.fallback});

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  T get value => property.value ?? fallback();

  @override
  set(S value) => property.set(value);
}
