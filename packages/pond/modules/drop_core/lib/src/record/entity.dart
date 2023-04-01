import 'package:drop_core/src/context/drop_core_context.dart';
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

  @override
  State getState(DropCoreContext context) =>
      value.getState(context).withId(id).withType(context.getRuntimeTypeRuntime(runtimeType));

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return '$runtimeType{id: [$id], value: [${value.scaffoldState}]';
  }

  @override
  Validator<void, String?> get validator => value;
}
