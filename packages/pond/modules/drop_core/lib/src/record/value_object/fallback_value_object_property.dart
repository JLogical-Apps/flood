import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackValueObjectProperty<T, S> with IsValueObjectProperty<T, S, FallbackValueObjectProperty<T, S>> {
  final ValueObjectProperty<T?, S, dynamic> property;

  final T Function() fallback;

  @override
  final Type getterType;

  @override
  Type get setterType => property.setterType;

  FallbackValueObjectProperty({required this.property, required this.fallback}) : getterType = T;

  @override
  State modifyState(DropCoreContext context, State state) {
    if (property.value == null) {
      return state.withData(state.data.copy()..set(property.name, fallback()));
    }
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
  FallbackValueObjectProperty<T, S> copy() {
    return FallbackValueObjectProperty<T, S>(property: property.copy(), fallback: fallback);
  }

  @override
  String get name => property.name;
}
