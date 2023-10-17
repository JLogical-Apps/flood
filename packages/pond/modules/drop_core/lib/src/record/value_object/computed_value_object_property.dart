import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class ComputedValueObjectProperty<T, L> with IsValueObjectProperty<T, void, L, ComputedValueObjectProperty<T, L>> {
  @override
  final String name;

  final T Function() computation;

  @override
  final Type getterType;

  @override
  final Type setterType;

  ComputedValueObjectProperty({required this.name, required this.computation})
      : getterType = T,
        setterType = T;

  @override
  State modifyState(State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  void set(void value) {
    throw Exception('Cannot set a Computed property!');
  }

  @override
  T get value => computation();

  @override
  T? get valueOrNull => guard(() => computation());

  @override
  ComputedValueObjectProperty<T, L> copy() {
    return ComputedValueObjectProperty<T, L>(name: name, computation: computation);
  }
}