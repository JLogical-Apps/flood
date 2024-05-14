import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class FallbackWithoutReplacementValueObjectProperty<T, S>
    with IsValueObjectPropertyWrapper<T, S, FallbackWithoutReplacementValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final T Function() fallback;

  @override
  final Type getterType;

  FallbackWithoutReplacementValueObjectProperty({required this.property, required this.fallback}) : getterType = T;

  FallbackWithoutReplacementValueObjectProperty.fromProperty({
    required ValueObjectProperty<T?, S, ValueObjectProperty> property,
    required this.fallback,
  })  : getterType = T,
        property = property.withMapper(
          getMapper: (value) => value ?? fallback(),
          setMapper: (value) => value,
        );

  @override
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallback());

  @override
  FallbackWithoutReplacementValueObjectProperty<T, S> copy() {
    return FallbackWithoutReplacementValueObjectProperty<T, S>(property: property.copy(), fallback: fallback);
  }
}
