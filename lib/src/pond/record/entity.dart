import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/pond/validation/validation_state.dart';
import 'package:rxdart/rxdart.dart';

import 'has_id.dart';

abstract class Entity<V extends ValueObject> extends Record with EquatableMixin implements HasId, Resolvable {
  String? id;

  final BehaviorSubject<V> _valueX = BehaviorSubject();

  Future<void> beforeSave() async {}
  Future<void> afterSave() async {}
  Future<void> beforeDelete() async {}
  Future<void> afterCreate() async {}

  V get value => _valueX.value;

  set value(V value) => _valueX.value = value;

  State get state => value.state.copyWith(id: id, type: runtimeType.toString());

  set state(State state) {
    id = state.id;
    value = ValueObject.fromState(state);
  }

  bool get isNew => id == null;

  void validateRecord() => value.validateRecord();

  ValidationState get validationState => value.validationState;

  @override
  Future resolve() {
    return value.resolve();
  }

  static E? fromStateOrNull<E extends Entity>(State state) {
    return AppContext.global.constructEntityFromStateOrNull(state) as E?;
  }

  static E fromState<E extends Entity>(State state) {
    return fromStateOrNull(state) ?? (throw Exception('Unable to convert state [$state] to a $E entity.'));
  }

  @override
  List<Object?> get props => [id];

  Future<void> create() {
    return AppContext.global.create(this);
  }

  Future<void> save() {
    return AppContext.global.save(this);
  }

  Future<void> createOrSave() {
    return AppContext.global.createOrSave(this);
  }

  Future<void> delete() {
    return AppContext.global.delete(this);
  }
}
