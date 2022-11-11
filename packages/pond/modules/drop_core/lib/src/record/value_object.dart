import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

abstract class ValueObject extends Record {
  List<ValueObjectBehavior> get behaviors => [];

  @override
  State get state {
    final state = behaviors.fold<State>(
      State(
        type: '$runtimeType',
        data: {},
      ),
      (state, behavior) => behavior.modifyState(state),
    );

    return state;
  }

  set state(State state) {
    for (final behavior in behaviors) {
      behavior.fromState(state);
    }
  }

  FieldValueObjectProperty<T> field<T>({required String name}) => ValueObjectProperty.field<T>(name: name);
}
