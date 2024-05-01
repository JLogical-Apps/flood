import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
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
      property.set([]);
    } else if (stateValue is List<T>) {
      property.set(stateValue);
    } else if (stateValue is List<State>) {
      property.set(stateValue.map((state) {
        final valueObject = (state.type!.createInstance() as T)..setState(context, state);
        valueObject.throwIfInvalid(null);
        return valueObject;
      }).toList());
    } else if (stateValue is List<dynamic>) {
      property.set(stateValue.cast<T>());
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
  ListEmbeddedValueObjectProperty<T> copy() {
    return ListEmbeddedValueObjectProperty(property: property.copy());
  }
}
