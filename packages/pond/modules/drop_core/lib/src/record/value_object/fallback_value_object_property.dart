import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackValueObjectProperty<T, S> with IsValueObjectPropertyWrapper<T, S, FallbackValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final ValueObjectProperty<T?, S, dynamic> rootProperty;

  final T Function() fallback;

  @override
  final Type getterType;

  FallbackValueObjectProperty({required this.property, required this.rootProperty, required this.fallback})
      : getterType = T;

  FallbackValueObjectProperty.fromProperty({
    required ValueObjectProperty<T?, S, ValueObjectProperty> property,
    required this.fallback,
  })  : getterType = T,
        rootProperty = property,
        property = property.withMapper(
          getMapper: (value) => value ?? fallback(),
          setMapper: (value) => value,
        );

  @override
  State modifyState(DropCoreContext context, State state) {
    if (rootProperty.value == null) {
      return state.withData(state.data.copy()..set(property.name, fallback()));
    }
    return property.modifyState(context, state);
  }

  @override
  T? get valueOrNull => rootProperty.valueOrNull ?? guard(() => fallback());

  @override
  FallbackValueObjectProperty<T, S> copy() {
    return FallbackValueObjectProperty<T, S>(
      property: property.copy(),
      rootProperty: rootProperty.copy(),
      fallback: fallback,
    );
  }
}
