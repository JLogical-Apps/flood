import 'package:drop_core/src/context/drop_core_context.dart';
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
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObject extends Record with EquatableMixin, IsValidatorWrapper<void, String> {
  List<ValueObjectBehavior> get behaviors => [];

  @override
  State getState(DropCoreContext context) {
    return getScaffoldState(context).withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  @override
  State getStateUnsafe(DropCoreContext context) {
    return getScaffoldStateUnsafe(context).withType(context.getRuntimeTypeRuntime(runtimeType));
  }

  Future<State> setRepositoryState(DropCoreContext context, State state) async {
    for (final behavior in behaviors) {
      state = await behavior.modifyStateForRepository(context, state);
      behavior.fromState(context, state);
    }
    setState(context, state);
    return state;
  }

  void setState(DropCoreContext context, State state) {
    for (final behavior in behaviors) {
      behavior.fromState(context, state);
    }
  }

  void setStateUnsafe(DropCoreContext context, State state) {
    for (final behavior in behaviors) {
      guard(() => behavior.fromState(context, state));
    }
  }

  /// An unsafe state of the ValueObject without the type set.
  State getScaffoldState(DropCoreContext context) => behaviors.fold<State>(
        State(data: {}),
        (state, behavior) => behavior.modifyState(context, state),
      );

  State getScaffoldStateUnsafe(DropCoreContext context) => behaviors.fold<State>(
        State(data: {}),
        (state, behavior) => guard(() => behavior.modifyState(context, state)) ?? state,
      );

  void copyFrom(DropCoreContext context, Stateful stateful) {
    setState(context, stateful.getState(context));
  }

  void copyFromUnsafe(DropCoreContext context, Stateful stateful) {
    setStateUnsafe(context, stateful.getStateUnsafe(context));
  }

  @override
  Validator<void, String> get validator => Validator((_) async {
        for (final behavior in behaviors) {
          final error = await behavior.validate(this);
          if (error != null) {
            return error;
          }
        }

        return null;
      });

  Map<String, dynamic> get rawPropertyValues =>
      behaviors.whereType<ValueObjectProperty>().mapToMap((property) => MapEntry(property.name, property.valueOrNull));

  @override
  List<Object> get props => [rawPropertyValues];

  FieldValueObjectProperty<T> field<T>({required String name}) => ValueObjectProperty.field<T>(name: name);

  ReferenceValueObjectProperty<E> reference<E extends Entity>({required String name}) =>
      ValueObjectProperty.reference<E>(name: name);

  ComputedValueObjectProperty<T> computed<T>({required String name, required T Function() computation}) =>
      ValueObjectProperty.computed<T>(name: name, computation: computation);

  CreationTimeProperty creationTime() => ValueObjectProperty.creationTime();
}
