import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ListValueObjectProperty<T, L> with IsValueObjectProperty<List<T>, List<T>, L, ListValueObjectProperty<T, L>> {
  final FieldValueObjectProperty<T, L> property;

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
  void fromState(State state) {
    value = (state[name] as List?)?.cast<T>() ?? [];
  }

  @override
  State modifyState(State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  ListValueObjectProperty<T, L> copy() {
    return ListValueObjectProperty<T, L>(property: property.copy(), value: value);
  }
}
