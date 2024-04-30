import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ListValueObjectProperty<T> with IsValueObjectProperty<List<T>, List<T>, ListValueObjectProperty<T>> {
  final ValueObjectProperty<T?, T?, dynamic> property;

  @override
  List<T> value;

  final Type valueType;

  final Type listType;

  ListValueObjectProperty({required this.property, List<T>? value})
      : value = value ?? [],
        valueType = T,
        listType = List<T>;

  @override
  Type get getterType => listType;

  @override
  Type get setterType => listType;

  @override
  String get name => property.name;

  @override
  set(List<T>? value) => this.value = value ?? [];

  @override
  void fromState(DropCoreContext context, State state) {
    value = (state[name] as List?)?.cast<T>() ?? [];
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  ListValueObjectProperty<T> copy() {
    return ListValueObjectProperty<T>(property: property.copy(), value: value);
  }
}
