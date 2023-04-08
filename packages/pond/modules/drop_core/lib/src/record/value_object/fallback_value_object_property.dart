import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class FallbackValueObjectProperty<T, S, L> with IsValueObjectProperty<T, S, L, FallbackValueObjectProperty<T, S, L>> {
  final ValueObjectProperty<T?, S, L, dynamic> property;

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

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  FallbackValueObjectProperty<T, S, L> copy() {
    return FallbackValueObjectProperty<T, S, L>(property: property.copy(), fallback: fallback);
  }
}
