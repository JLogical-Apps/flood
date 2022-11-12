import 'package:drop_core/src/record/record.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

abstract class Entity<V extends ValueObject> extends Record with EquatableMixin {
  String? id;

  final BehaviorSubject<V> _valueObjectX = BehaviorSubject();

  Type get valueObjectType => V;

  V get value => _valueObjectX.value;

  set value(V valueObject) => _valueObjectX.value = valueObject;

  @override
  State get state => value.state.withId(id).withType('$runtimeType');

  @override
  List<Object?> get props => [id];
}
