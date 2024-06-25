import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:runtime_type/type.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Entity<V extends ValueObject> extends Record with EquatableMixin, IsValidatorWrapper<void, String?> {
  String? id;

  final BehaviorSubject<V> _valueObjectX = BehaviorSubject();

  Type get valueObjectType => V;

  bool get hasValue => _valueObjectX.hasValue;

  V get value => _valueObjectX.value;

  set value(V valueObject) => _valueObjectX.value = valueObject..entity = this;

  void set(V valueObject) => value = valueObject;

  bool get isNew => id == null;

  @override
  State getState(DropCoreContext context) => value
      .getState(context)
      .withId(id ?? value.idToUse)
      .withIsNew(id == null)
      .withType(context.getRuntimeTypeRuntime(runtimeType));

  @override
  State getStateUnsafe(DropCoreContext context) => value
      .getStateUnsafe(context)
      .withId(id ?? value.idToUse)
      .withIsNew(id == null)
      .withType(context.getRuntimeTypeRuntime(runtimeType));

  FutureOr<State?> onBeforeInitialize(DropCoreContext context, {required State state}) {
    return null;
  }

  FutureOr onAfterInitalize(DropCoreContext context) {}

  FutureOr onBeforeCreate(DropCoreContext context) {}

  FutureOr onAfterCreate(DropCoreContext context) {}

  FutureOr onBeforeSave(DropCoreContext context) {}

  FutureOr onAfterSave(DropCoreContext context) {}

  FutureOr onBeforeDelete(DropCoreContext context) {}

  FutureOr onAfterDelete(DropCoreContext context) {}

  Future<State?> beforeInitialize(DropCoreContext context, {required State state}) async {
    return await onBeforeInitialize(context, state: state);
  }

  Future<void> afterInitialize(DropCoreContext context) async {
    return await onAfterInitalize(context);
  }

  Future<void> beforeCreate(DropCoreContext context) async {
    return await onBeforeCreate(context);
  }

  Future<void> afterCreate(DropCoreContext context) async {
    return await onAfterCreate(context);
  }

  Future<void> beforeSave(DropCoreContext context) async {
    return await onBeforeSave(context);
  }

  Future<void> afterSave(DropCoreContext context) async {
    return await onAfterSave(context);
  }

  Future<void> beforeDelete(DropCoreContext context) async {
    await value.onDelete(context);
    return await onBeforeDelete(context);
  }

  Future<void> afterDelete(DropCoreContext context) async {
    return await onAfterDelete(context);
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return '$runtimeType{id: [$id], value: [${value.rawPropertyValues}]';
  }

  @override
  Validator<void, String?> get validator => value;
}
