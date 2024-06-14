import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FieldValueObjectProperty<T> with IsValueObjectProperty<T?, T?, FieldValueObjectProperty<T>> {
  @override
  late ValueObject valueObject;

  @override
  final String name;

  @override
  T? value;

  final Type fieldType;

  FieldValueObjectProperty({required this.name, this.value}) : fieldType = T;

  @override
  Type get getterType => fieldType;

  @override
  Type get setterType => fieldType;

  @override
  set(T? value) => this.value = value;

  @override
  void fromState(DropCoreContext context, State state) {
    try {
      value = coerceOrNull<T>(state[name]);
    } catch (e) {
      throw Exception('Could not set value of [$name] to [${state[name]}] due to:\n$e');
    }
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  String toString() {
    return 'field<$T>(name: $name)';
  }

  @override
  FieldValueObjectProperty<T> copy() {
    return FieldValueObjectProperty<T>(name: name, value: value)..valueObject = valueObject;
  }
}
