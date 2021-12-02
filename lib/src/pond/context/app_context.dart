import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/export.dart';

import 'app_registration.dart';

class AppContext {
  static late AppContext global = AppContext();

  final AppRegistration registration;
  final Database database;

  AppContext({
    AppRegistration? registration,
    Database? database,
  })  : this.registration = registration ?? AppRegistration(),
        this.database = database ?? Database(repositories: []);

  E constructEntity<E extends Entity<V>, V extends ValueObject>(V initialState) {
    return registration.constructEntity<E, V>(initialState);
  }

  Entity constructEntityRuntime(Type entityType, ValueObject initialState) {
    return registration.constructEntityRuntime(entityType, initialState);
  }

  V constructValueObject<V extends ValueObject>() {
    return registration.constructValueObject<V>();
  }

  ValueObject constructValueObjectRuntime(Type valueObjectType) {
    return registration.constructValueObjectRuntime(valueObjectType);
  }

  ValueObject? constructValueObjectFromStateOrNull(State state) {
    return registration.constructValueObjectFromStateOrNull(state);
  }

  Entity? constructEntityFromStateOrNull(State state) {
    return registration.constructEntityFromStateOrNull(state);
  }

  Aggregate constructAggregateFromEntityRuntime(Type aggregateType, Entity entity) {
    return registration.constructAggregateFromEntityRuntime(aggregateType, entity);
  }

  Type getEntityTypeFromAggregate<A>() {
    return registration.getEntityTypeFromAggregate<A>();
  }

  TypeStateSerializer<T> getTypeStateSerializerByType<T>() {
    return registration.getTypeStateSerializerByType<T>();
  }

  TypeStateSerializer getTypeStateSerializerByRuntimeType(Type type) {
    return registration.getTypeStateSerializerByRuntimeType(type);
  }
}
