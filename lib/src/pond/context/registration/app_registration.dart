import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

abstract class AppRegistration {
  Environment get environment;

  Database get database;

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType);

  ValueObject? constructValueObjectFromStateOrNull(State state);

  Entity? constructEntityRuntimeOrNull(ValueObject initialState);

  Aggregate? constructAggregateFromEntityRuntimeOrNull(Entity entity);

  Type getEntityTypeFromAggregate(Type aggregateType);

  TypeStateSerializer getTypeStateSerializerByTypeRuntime(Type type);

  bool isSubtype(Type a, Type b);

  Set<Type> getDescendants(Type type);

  void register<T extends Object>(T lazyGetter());

  T locate<T extends Object>();
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

  Aggregate constructAggregateFromEntityRuntime(Entity entity) {
    return constructAggregateFromEntityRuntimeOrNull(entity) ??
        (throw Exception('Could not construct an Aggregate from the entity [$entity]'));
  }

  A constructAggregateFromEntity<A extends Aggregate>(Entity entity) {
    return constructAggregateFromEntityRuntime(entity) as A;
  }

  TypeStateSerializer getTypeStateSerializerByType<T>() {
    return getTypeStateSerializerByTypeRuntime(T);
  }

  void registerModule(AppModule module) {
    module.onRegister(this);
  }
}
