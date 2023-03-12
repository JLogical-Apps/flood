import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class ComputedValueObjectProperty<T, L> with IsValueObjectProperty<T, void, L> {
  final String name;

  final T Function() computation;

  ComputedValueObjectProperty({required this.name, required this.computation});

  @override
  void fromState(State state) {
    // Do nothing.
  }

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
}
