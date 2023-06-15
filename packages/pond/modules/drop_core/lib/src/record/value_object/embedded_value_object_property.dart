import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class EmbeddedValueObjectProperty<G extends ValueObject?, S extends ValueObject?, L>
    with IsValueObjectPropertyWrapper<G, S, L, EmbeddedValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  EmbeddedValueObjectProperty({required this.property});

  @override
  void fromState(State state) {
    final stateValue = state.data[property.name];
    if (stateValue == null) {
      property.set(null as S);
    } else if (stateValue is G) {
      property.set(stateValue as S);
    } else if (stateValue is S) {
      property.set(stateValue);
    } else if (stateValue is State) {
      final valueObject = (stateValue.type!.createInstance() as ValueObject)..state = stateValue;
     //  valueObject.throwIfInvalid(null);
      property.set(valueObject as S);
    } else {
      throw Exception('Unknown ValueObject value: [$stateValue]');
    }
  }

  @override
  EmbeddedValueObjectProperty<G, S, L> copy() {
    return EmbeddedValueObjectProperty(property: property.copy());
  }
}
