import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ListValueObjectProperty<T> with IsValueObjectProperty<List<T>, List<T>, ListValueObjectProperty<T>> {
  final ValueObjectProperty<T?, T?, dynamic> property;

  @override
  List<T> value;

  final Type valueType;

  final Type listType;

  late List<ValueObjectProperty<T?, T?, ValueObjectProperty>> properties =
      value.map((item) => property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>..set(item)).toList();

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
  Future<void> onDuplicateTo(DropCoreContext context, ValueObjectBehavior behavior) async {
    behavior as ListValueObjectProperty<T>;
    for (final (i, property) in properties.indexed) {
      final otherItemProperty = behavior.properties[i];
      await property.onDuplicateTo(context, otherItemProperty);
    }

    behavior.set(behavior.properties.map((property) => property.value).whereNonNull().toList());
  }

  @override
  Future<void> onBeforeSave(DropCoreContext context) async {
    for (final property in properties) {
      await property.onBeforeSave(context);
    }
  }

  @override
  Future<void> onDelete(DropCoreContext context) async {
    for (final property in properties) {
      await property.onDelete(context);
    }
  }

  @override
  ListValueObjectProperty<T> copy() {
    return ListValueObjectProperty<T>(property: property.copy(), value: value);
  }

  @override
  ValueObject get valueObject => property.valueObject;

  @override
  set valueObject(ValueObject value) => property.valueObject = value;
}
