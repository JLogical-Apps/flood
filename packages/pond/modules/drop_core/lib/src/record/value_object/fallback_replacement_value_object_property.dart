import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackReplacementValueObjectProperty<T>
    with IsValueObjectProperty<T, T?, FallbackReplacementValueObjectProperty<T>> {
  final ValueObjectProperty<T?, T?, dynamic> property;

  final T Function() fallbackReplacement;

  @override
  final Type getterType;

  @override
  Type get setterType => property.setterType;

  FallbackReplacementValueObjectProperty({required this.property, required this.fallbackReplacement}) : getterType = T;

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
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallbackReplacement());

  @override
  set(T? value) => property.set(value);

  @override
  FallbackReplacementValueObjectProperty<T> copy() {
    return FallbackReplacementValueObjectProperty<T>(
      property: property.copy(),
      fallbackReplacement: fallbackReplacement,
    );
  }

  @override
  String get name => property.name;
}
