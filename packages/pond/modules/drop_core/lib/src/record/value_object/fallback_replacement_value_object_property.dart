import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class FallbackReplacementValueObjectProperty<T> implements ValueObjectProperty<T, T> {
  final ValueObjectProperty<T?, T> property;

  final T Function() fallbackReplacement;

  FallbackReplacementValueObjectProperty({required this.property, required this.fallbackReplacement});

  @override
  State modifyState(State state) {
    if (property.value == null) {
      property.set(fallbackReplacement());
    }

    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  T get value => property.value ?? fallbackReplacement();

  @override
  set(T value) => property.set(value);
}
