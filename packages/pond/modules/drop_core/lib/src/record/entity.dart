import 'dart:async';

import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class Entity<V extends ValueObject> extends Record with EquatableMixin, IsValidatorWrapper<void, String?> {
  String? id;

  final BehaviorSubject<V> _valueObjectX = BehaviorSubject();

  Type get valueObjectType => V;

  bool get hasValue => _valueObjectX.hasValue;

  V get value => _valueObjectX.value;

  set value(V valueObject) => _valueObjectX.value = valueObject;

  void set(V valueObject) => value = valueObject;

  bool get isNew => id == null;

  @override
  State getState(CoreDropContext context) =>
      value.getState(context).withId(id).withType(context.getRuntimeTypeRuntime(runtimeType));

  @override
  State getStateUnsafe(CoreDropContext context) =>
      value.getStateUnsafe(context).withId(id).withType(context.getRuntimeTypeRuntime(runtimeType));

  FutureOr<State?> onBeforeInitialize(CoreDropContext context, {required State state}) {
    return null;
  }

  FutureOr onAfterInitalize(CoreDropContext context) {}

  FutureOr onBeforeCreate(CoreDropContext context) {}

  FutureOr onAfterCreate(CoreDropContext context) {}

  FutureOr onBeforeSave(CoreDropContext context) {}

  FutureOr onAfterSave(CoreDropContext context) {}

  FutureOr onBeforeDelete(CoreDropContext context) {}

  FutureOr onAfterDelete(CoreDropContext context) {}

  Future<State?> beforeInitialize(CoreDropContext context, {required State state}) async {
    return await onBeforeInitialize(context, state: state);
  }

  Future<void> afterInitialize(CoreDropContext context) async {
    return await onAfterInitalize(context);
  }

  Future<void> beforeCreate(CoreDropContext context) async {
    return await onBeforeCreate(context);
  }

  Future<void> afterCreate(CoreDropContext context) async {
    return await onAfterCreate(context);
  }

  Future<void> beforeSave(CoreDropContext context) async {
    return await onBeforeSave(context);
  }

  Future<void> afterSave(CoreDropContext context) async {
    return await onAfterSave(context);
  }

  Future<void> beforeDelete(CoreDropContext context) async {
    return await onBeforeDelete(context);
  }

  Future<void> afterDelete(CoreDropContext context) async {
    return await onAfterDelete(context);
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return '$runtimeType{id: [$id], value: [$value]';
  }

  @override
  Validator<void, String?> get validator => value;
}
