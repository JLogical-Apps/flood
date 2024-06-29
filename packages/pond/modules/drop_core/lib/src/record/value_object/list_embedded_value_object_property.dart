import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class ListEmbeddedValueObjectProperty<T extends ValueObject>
    with IsValueObjectPropertyWrapper<List<T>, List<T>, ListEmbeddedValueObjectProperty<T>> {
  @override
  final ValueObjectProperty<List<T>, List<T>, dynamic> property;

  ListEmbeddedValueObjectProperty({required this.property});

  @override
  void fromState(DropCoreContext context, State state) {
    final stateValue = state.data[property.name];
    if (stateValue == null) {
      set([]);
    } else if (stateValue is List<T>) {
      set(stateValue);
    } else if (stateValue is List<State>) {
      set(stateValue.map((state) {
        final valueObject = (state.type!.createInstance() as T)..setState(context, state);
        valueObject.throwIfInvalid(null);
        return valueObject;
      }).toList());
    } else if (stateValue is List<dynamic>) {
      set(stateValue.cast<T>());
    } else {
      throw Exception('Unknown ValueObject value: [$stateValue]');
    }
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()
      ..set(
        name,
        value.map((valueObject) => valueObject.getState(context)).toList(),
      ));
  }

  @override
  void set(List<T> value) {
    for (final valueObject in value) {
      valueObject
        ..entity = this.valueObject.entity
        ..idToUse = this.valueObject.idToUse;
    }

    property.set(value);
  }

  @override
  Future<void> onBeforeSave(DropCoreContext context) async {
    for (final valueObject in value) {
      await valueObject.onBeforeSave(context);
    }
  }

  @override
  Future<void> onDuplicateTo(DropCoreContext context, ListEmbeddedValueObjectProperty<T> property) async {
    for (final (i, value) in property.value.indexed) {
      await value.duplicateFrom(context, this.value[i]);
    }
  }

  @override
  Future<void> onDelete(DropCoreContext context) async {
    for (final valueObject in value) {
      await valueObject.onDelete(context);
    }
  }

  @override
  ListEmbeddedValueObjectProperty<T> copy() {
    return ListEmbeddedValueObjectProperty(property: property.copy());
  }
}
