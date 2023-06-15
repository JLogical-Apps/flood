import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class ComputedValueObjectProperty<T, L> with IsValueObjectProperty<T, void, L, ComputedValueObjectProperty<T, L>> {
  @override
  final String name;

  final T Function() computation;

  ComputedValueObjectProperty({required this.name, required this.computation});

  @override
  State modifyState(CoreDropContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  void set(void value) {
    throw Exception('Cannot set a Computed property!');
  }

  @override
  T get value => computation();

  @override
  ComputedValueObjectProperty<T, L> copy() {
    return ComputedValueObjectProperty<T, L>(name: name, computation: computation);
  }

  @override
  List<Object?> get props => [name];
}
