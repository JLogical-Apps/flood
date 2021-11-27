import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/resolvable.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/validation/validation_state.dart';
import 'package:rxdart/rxdart.dart';

import 'has_id.dart';

abstract class Entity<V extends ValueObject> extends Record with EquatableMixin implements HasId, Resolvable {
  String? id;

  BehaviorSubject<V> _valueX;

  V get value => _valueX.value;

  set value(V value) => _valueX.value = value;

  Entity({required V initialValue}) : _valueX = BehaviorSubject.seeded(initialValue);

  State get state => value.state.copyWith(id: id, type: runtimeType.toString());

  set state(State state) => value = ValueObject.fromState(state);

  void onValidate() => value.onValidate();

  ValidationState get validationState => value.validationState;

  @override
  Future resolve(AppContext context) {
    return value.resolve(context);
  }

  static E? fromStateOrNull<E extends Entity>(State state) {
    return AppContext.global.constructEntityFromStateOrNull(state) as E?;
  }

  static Entity? fromStateRuntimeOrNull({required State state}) {
    return AppContext.global.constructEntityFromStateOrNull(state);
  }

  @override
  List<Object?> get props => [id];
}
