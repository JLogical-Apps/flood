import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class EmbeddedValueObjectProperty<G extends ValueObject?, S extends ValueObject?>
    with IsValueObjectPropertyWrapper<G, S, EmbeddedValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  EmbeddedValueObjectProperty({required this.property});

  @override
  void fromState(DropCoreContext context, State state) {
    final stateValue = state.data[property.name];
    if (stateValue == null) {
      property.set(null as S);
    } else if (stateValue is G) {
      property.set(stateValue as S);
    } else if (stateValue is S) {
      property.set(stateValue);
    } else if (stateValue is State) {
      final valueObject = (stateValue.type!.createInstance() as ValueObject)..setState(context, stateValue);
      valueObject.throwIfInvalid(null);
      property.set(valueObject as S);
    } else {
      throw Exception('Unknown ValueObject value: [$stateValue]');
    }
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()..set(name, value?.getState(context)));
  }

  @override
  EmbeddedValueObjectProperty<G, S> copy() {
    return EmbeddedValueObjectProperty(property: property.copy());
  }
}
