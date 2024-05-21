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
    value = (state[name] as List?)
            ?.map((item) {
              final itemProperty = property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>;
              final itemState = State(data: {name: item});
              itemProperty.fromState(context, itemState);
              return itemProperty.value;
            })
            .whereNonNull()
            .toList() ??
        [];
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()
      ..set(
        name,
        value.map((item) {
          final itemProperty = property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>;
          itemProperty.set(item);

          var emulatedState = State(data: {});
          emulatedState = itemProperty.modifyState(context, emulatedState);
          return emulatedState.data[name];
        }).toList(),
      ));
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    return state.withData(state.data.copy()
      ..set(
        name,
        await Future.wait(value.map((item) async {
          final itemProperty = property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>;
          itemProperty.set(item);

          var emulatedState = State(data: {name: item});
          emulatedState = await itemProperty.modifyStateForRepository(context, emulatedState);
          return emulatedState.data[name];
        }).toList()),
      ));
  }

  @override
  ListValueObjectProperty<T> copy() {
    return ListValueObjectProperty<T>(property: property.copy(), value: value);
  }
}
