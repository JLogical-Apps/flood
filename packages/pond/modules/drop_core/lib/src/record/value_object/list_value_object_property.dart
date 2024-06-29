import 'package:collection/collection.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ListValueObjectProperty<T> with IsValueObjectProperty<List<T>, List<T>, ListValueObjectProperty<T>> {
  final ValueObjectProperty<T?, T?, dynamic> property;

  List<ValueObjectProperty<T?, T?, ValueObjectProperty>> properties;

  @override
  List<T> get value => properties.map((property) => property.value).whereNonNull().toList();

  final Type valueType;

  final Type listType;

  ListValueObjectProperty({
    required this.property,
    List<ValueObjectProperty<T?, T?, ValueObjectProperty>>? properties,
    List<T>? value,
  })  : properties = properties ??
            (value ?? [])
                .map((item) => property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>..set(item))
                .toList(),
        valueType = T,
        listType = List<T>;

  @override
  Type get getterType => listType;

  @override
  Type get setterType => listType;

  @override
  String get name => property.name;

  @override
  set(List<T>? value) => properties = (value ?? [])
      .map((item) => property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>..set(item))
      .toList();

  @override
  void fromState(DropCoreContext context, State state) {
    final data = state.data[name] as List?;
    final metadata = state.metadata[name] as List?;
    properties = [];

    if (data == null) {
      return;
    }

    data.forEachIndexed((i, value) {
      final itemProperty = property.copy() as ValueObjectProperty<T?, T?, ValueObjectProperty>;
      final itemState = State(
        data: {name: value},
        metadata: {name: metadata?.elementAtOrNull(i)},
      );

      itemProperty.fromState(context, itemState);
      properties.add(itemProperty);
    });
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    final datas = [];
    final metadatas = [];

    properties.forEachIndexed((i, property) {
      var emulatedState = State(data: {});
      emulatedState = property.modifyState(context, emulatedState);
      datas.add(emulatedState.data[name]);
      metadatas.add(emulatedState.metadata[name]);
    });

    return state.copyWith(
      id: state.id,
      type: state.type,
      data: state.data.copy()..set(name, datas),
      metadata: state.metadata.copy()..set(name, metadatas),
    );
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    final datas = [];
    final metadatas = [];

    for (final property in properties) {
      var emulatedState = State(data: {});
      emulatedState = property.modifyState(context, emulatedState);
      emulatedState = await property.modifyStateForRepository(context, emulatedState);
      datas.add(emulatedState.data[name]);
      metadatas.add(emulatedState.metadata[name]);
    }

    return state.copyWith(
      id: state.id,
      type: state.type,
      data: state.data.copy()..set(name, datas),
      metadata: state.metadata.copy()..set(name, metadatas),
    );
  }

  @override
  Future<void> onDuplicateTo(DropCoreContext context, ValueObjectBehavior behavior) async {
    behavior as ListValueObjectProperty<T>;
    for (final (i, property) in properties.indexed) {
      final otherItemProperty = behavior.properties[i];
      await property.onDuplicateTo(context, otherItemProperty);
    }
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
    return ListValueObjectProperty<T>(
      property: property.copy(),
      value: value,
      properties: properties,
    );
  }

  @override
  ValueObject get valueObject => property.valueObject;

  @override
  set valueObject(ValueObject value) => property.valueObject = value;
}
