import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

abstract class AppRegistration {
  Database get database;

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType);

  ValueObject? constructValueObjectFromStateOrNull(State state);

  Entity? constructEntityRuntimeOrNull(ValueObject initialState);

  TypeStateSerializer getTypeStateSerializerByTypeRuntime(Type type);

  bool isSubtype(Type a, Type b);

  Set<Type> getDescendants(Type type);

  void register<T>(T obj);

  T? locateOrNull<T>();
}

extension DefaultAppRegistration on AppRegistration {
  Entity constructEntityRuntime(ValueObject initialState) {
    return constructEntityRuntimeOrNull(initialState) ??
        (throw Exception('Could not construct an entity from value object [$initialState]'));
  }

  E constructEntity<E extends Entity<V>, V extends ValueObject>(V initialState) {
    return constructEntityRuntime(initialState) as E;
  }

  ValueObject constructValueObjectRuntime(Type valueObjectType) {
    return constructValueObjectRuntimeOrNull(valueObjectType) ??
        (throw Exception('Could not construct a ValueObject of type [$valueObjectType]'));
  }

  V constructValueObject<V extends ValueObject>() {
    return constructValueObjectRuntime(V) as V;
  }

  V? constructValueObjectOrNull<V extends ValueObject>() {
    return constructValueObjectRuntimeOrNull(V) as V?;
  }

  ValueObject constructValueObjectFromState(State state) {
    return constructValueObjectFromStateOrNull(state) ??
        (throw Exception('Could not construct a ValueObject from the state [$state]'));
  }

  Entity? constructEntityFromStateOrNull(State state) {
    final valueObject = constructValueObjectFromStateOrNull(state);
    if (valueObject == null) {
      return null;
    }

    final entity = constructEntityRuntimeOrNull(valueObject);
    entity?.id = state.id;

    return entity;
  }

  Entity constructEntityFromState(State state) {
    return constructEntityFromStateOrNull(state) ??
        (throw Exception('Could not construct an Entity from the state [$state]'));
  }

  TypeStateSerializer getTypeStateSerializerByType<T>() {
    return getTypeStateSerializerByTypeRuntime(T);
  }

  T locate<T>() {
    return locateOrNull() ?? (throw Exception('Could not locate [$T]'));
  }
}
