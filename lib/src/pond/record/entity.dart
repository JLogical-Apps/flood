import 'package:jlogical_utils/src/pond/export.dart';
import 'package:rxdart/rxdart.dart';

import 'has_id.dart';

abstract class Entity<V extends ValueObject> implements HasId {
  String? id;

  BehaviorSubject<V> _stateX;

  V get state => _stateX.value;

  set state(V value) => _stateX.value = value;

  Entity({required V initialState}) : _stateX = BehaviorSubject.seeded(initialState);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
