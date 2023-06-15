import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ListValueObjectProperty<T, L> with IsValueObjectProperty<List<T>, List<T>, L, ListValueObjectProperty<T, L>> {
  final FieldValueObjectProperty<T, L> property;

  @override
  List<T> value;

  ListValueObjectProperty({required this.property, List<T>? value}) : value = value ?? [];

  @override
  String get name => property.name;

  @override
  set(List<T>? value) => this.value = value ?? [];

  @override
  void fromState(CoreDropContext context, State state) {
    value = (state[name] as List?)?.cast<T>() ?? [];
  }

  @override
  State modifyState(CoreDropContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  Future<L> load(CoreDropContext context) => property.load(context);

  @override
  ListValueObjectProperty<T, L> copy() {
    return ListValueObjectProperty<T, L>(property: property.copy(), value: value);
  }

  @override
  List<Object?> get props => [property];
}
