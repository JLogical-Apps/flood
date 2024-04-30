import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackWithoutReplacementValueObjectProperty<T, S>
    with IsValueObjectProperty<T, S, FallbackWithoutReplacementValueObjectProperty<T, S>> {
  final ValueObjectProperty<T?, S, dynamic> property;

  final T Function() fallback;

  @override
  final Type getterType;

  @override
  Type get setterType => property.setterType;

  FallbackWithoutReplacementValueObjectProperty({required this.property, required this.fallback}) : getterType = T;

  @override
  State modifyState(DropCoreContext context, State state) {
    return property.modifyState(context, state);
  }

  @override
  void fromState(DropCoreContext context, State state) {
    property.fromState(context, state);
  }

  @override
  T get value => property.value ?? fallback();

  @override
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallback());

  @override
  set(S value) => property.set(value);

  @override
  FallbackWithoutReplacementValueObjectProperty<T, S> copy() {
    return FallbackWithoutReplacementValueObjectProperty<T, S>(property: property.copy(), fallback: fallback);
  }

  @override
  String get name => property.name;
}
