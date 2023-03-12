import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object/computed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/reference_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:equatable/equatable.dart';
import 'package:type/type.dart';

abstract class ValueObject extends Record with EquatableMixin {
  List<ValueObjectBehavior> get behaviors => [];

  @override
  State getState(DropCoreContext context) {
    return scaffoldState.withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  set state(State state) {
    for (final behavior in behaviors) {
      behavior.fromState(state);
    }
  }

  /// The state of the ValueObject without the type set.
  State get scaffoldState {
    final state = behaviors.fold<State>(
      State(data: {}),
      (state, behavior) => behavior.modifyState(state),
    );

    return state;
  }

  @override
  State getStateUnsafe(DropCoreContext context) {
    return scaffoldStateUnsafe.withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  State get scaffoldStateUnsafe {
    final state = behaviors.fold<State>(
      State(data: {}),
      (state, behavior) => behavior.modifyStateUnsafe(state),
    );

    return state;
  }

  void copyFrom(DropCoreContext context, Stateful stateful) {
    state = stateful.getState(context);
  }

  void copyFromUnsafe(DropCoreContext context, Stateful stateful) {
    state = stateful.getStateUnsafe(context);
  }

  @override
  List<Object> get props => [scaffoldState];

  FieldValueObjectProperty<T, dynamic> field<T>({required String name}) => ValueObjectProperty.field<T>(name: name);

  ReferenceValueObjectProperty<E> reference<E extends Entity>({required String name}) =>
      ValueObjectProperty.reference<E>(name: name);

  ComputedValueObjectProperty<T, dynamic> computed<T>({required String name, required T Function() computation}) =>
      ValueObjectProperty.computed(name: name, computation: computation);
}
