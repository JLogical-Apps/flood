import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class TimeValueObjectProperty<G extends Timestamp?, S extends Timestamp?>
    with IsValueObjectPropertyWrapper<G, S, TimeValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  TimeValueObjectProperty({required this.property});

  @override
  void fromState(State state) {
    final stateValue = state.data[property.name];
    if (stateValue == null) {
      property.set(null as S);
    } else if (stateValue is DateTime) {
      property.set(Timestamp.of(stateValue) as S);
    } else if (stateValue is Timestamp) {
      property.set(stateValue as S);
    } else if (stateValue is int) {
      property.set(Timestamp.of(DateTime.fromMillisecondsSinceEpoch(stateValue)) as S);
    } else if (stateValue is String) {
      property.set(Timestamp.of(DateTime.parse(stateValue)) as S);
    } else {
      throw Exception('Unknown time value: [$stateValue]');
    }
  }

  @override
  TimeValueObjectProperty<G, S> copy() {
    return TimeValueObjectProperty(property: property.copy());
  }
}
