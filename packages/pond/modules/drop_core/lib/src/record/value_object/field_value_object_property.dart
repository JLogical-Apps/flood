import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FieldValueObjectProperty<T, L> with IsValueObjectProperty<T?, T?, L, FieldValueObjectProperty<T, L>> {
  final String name;

  @override
  T? value;

  final Type fieldType;

  FieldValueObjectProperty({required this.name, this.value}) : fieldType = T;

  @override
  set(T? value) => this.value = value;

  @override
  void fromState(State state) {
    value = state[name] as T?;
  }

  @override
  State modifyState(State state) {
    if (value == null) {
      return state;
    }

    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  String toString() {
    return 'field<$T>(name: $name)';
  }

  @override
  FieldValueObjectProperty<T, L> copy() {
    return FieldValueObjectProperty<T, L>(name: name, value: value);
  }
}
