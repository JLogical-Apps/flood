import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object/computed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/reference_value_object_property.dart';
import 'package:drop_core/src/record/value_object/time/creation_time_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:equatable/equatable.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObject extends Record with EquatableMixin, IsValidatorWrapper<void, String> {
  List<ValueObjectBehavior> get behaviors => [];

  @override
  State getState(CoreDropContext context) {
    return getScaffoldState(context).withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  @override
  State getStateUnsafe(CoreDropContext context) {
    return getScaffoldStateUnsafe(context).withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  setState(CoreDropContext context, State state) {
    for (final behavior in behaviors) {
      behavior.fromState(context, state);
    }
  }

  void setStateUnsafe(CoreDropContext context, State state) {
    for (final behavior in behaviors) {
      guard(() => behavior.fromState(context, state));
    }
  }

  /// An unsafe state of the ValueObject without the type set.
  State getScaffoldState(CoreDropContext context) =>
      behaviors.fold<State>(
        State(data: {}),
            (state, behavior) => behavior.modifyState(context, state),
      );

  State getScaffoldStateUnsafe(CoreDropContext context) =>
      behaviors.fold<State>(
        State(data: {}),
            (state, behavior) => guard(() => behavior.modifyState(context, state)) ?? state,
      );

  void copyFrom(CoreDropContext context, Stateful stateful) {
    setState(context, stateful.getState(context));
  }

  void copyFromUnsafe(CoreDropContext context, Stateful stateful) {
    setStateUnsafe(context, stateful.getStateUnsafe(context));
  }

  @override
  Validator<void, String> get validator =>
      Validator((_) async {
        for (final behavior in behaviors) {
          final error = await behavior.validate(this);
          if (error != null) {
            return error;
          }
        }

        return null;
      });

  @override
  List<Object> get props => [behaviors];

  FieldValueObjectProperty<T, dynamic> field<T>({required String name}) => ValueObjectProperty.field<T>(name: name);

  ReferenceValueObjectProperty<E> reference<E extends Entity>({required String name}) =>
      ValueObjectProperty.reference<E>(name: name);

  ComputedValueObjectProperty<T, dynamic> computed<T>({required String name, required T Function() computation}) =>
      ValueObjectProperty.computed(name: name, computation: computation);

  CreationTimeProperty creationTime() => ValueObjectProperty.creationTime();

  @override
  String toString() {
    return behaviors.join(', ');
  }
}
