import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackWithoutReplacementValueObjectProperty<T, S, L>
    with IsValueObjectProperty<T, S, L, FallbackWithoutReplacementValueObjectProperty<T, S, L>> {
  final ValueObjectProperty<T?, S, L, dynamic> property;

  final T Function() fallback;

  @override
  final Type getterType;

  @override
  Type get setterType => property.setterType;

  FallbackWithoutReplacementValueObjectProperty({required this.property, required this.fallback}) : getterType = T;

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
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallback());

  @override
  set(S value) => property.set(value);

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  FallbackWithoutReplacementValueObjectProperty<T, S, L> copy() {
    return FallbackWithoutReplacementValueObjectProperty<T, S, L>(property: property.copy(), fallback: fallback);
  }

  @override
  String get name => property.name;
}
