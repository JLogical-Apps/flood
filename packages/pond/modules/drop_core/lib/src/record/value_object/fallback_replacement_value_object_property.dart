import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackReplacementValueObjectProperty<T>
    with IsValueObjectPropertyWrapper<T, T?, FallbackReplacementValueObjectProperty<T>> {
  @override
  final ValueObjectProperty<T, T?, dynamic> property;

  final ValueObjectProperty<T?, T?, dynamic> rootProperty;

  final T Function() fallbackReplacement;

  @override
  final Type getterType;

  FallbackReplacementValueObjectProperty({
    required this.property,
    required this.rootProperty,
    required this.fallbackReplacement,
  }) : getterType = T;

  FallbackReplacementValueObjectProperty.fromProperty({
    required ValueObjectProperty<T?, T?, ValueObjectProperty> property,
    required this.fallbackReplacement,
  })  : getterType = T,
        rootProperty = property,
        property = property.withMapper(
          getMapper: (value) => value ?? fallbackReplacement(),
          setMapper: (value) => value,
        );

  @override
  State modifyState(DropCoreContext context, State state) {
    if (rootProperty.value == null) {
      property.set(fallbackReplacement());
    }

    return property.modifyState(context, state);
  }

  @override
  T? get valueOrNull => rootProperty.valueOrNull ?? guard(() => fallbackReplacement());

  @override
  FallbackReplacementValueObjectProperty<T> copy() {
    return FallbackReplacementValueObjectProperty<T>(
      property: property.copy(),
      rootProperty: rootProperty.copy(),
      fallbackReplacement: fallbackReplacement,
    );
  }
}
