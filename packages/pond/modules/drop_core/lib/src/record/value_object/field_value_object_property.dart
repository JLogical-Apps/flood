import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FieldValueObjectProperty<T> with IsValueObjectProperty<T?> {
  final String name;

  @override
  T? value;

  FieldValueObjectProperty({required this.name, this.value});

  @override
  void fromState(State state) {
    value = state[name] as T?;
  }

  @override
  State modifyState(State state) {
    return state.withData(state.data.copy()..set(name, value));
  }
}
