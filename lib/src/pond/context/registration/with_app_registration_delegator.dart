import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

mixin WithAppRegistrationDelegator implements AppRegistration {
  AppRegistration get appRegistration;

  Entity? constructEntityRuntimeOrNull(ValueObject initialState) {
    return appRegistration.constructEntityRuntimeOrNull(initialState);
  }

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType) {
    return appRegistration.constructValueObjectRuntimeOrNull(valueObjectType);
  }

  ValueObject? constructValueObjectFromStateOrNull(State state) {
    return appRegistration.constructValueObjectFromStateOrNull(state);
  }

  Aggregate? constructAggregateFromEntityRuntimeOrNull(Entity entity) {
    return appRegistration.constructAggregateFromEntityRuntimeOrNull(entity);
  }

  A constructAggregateFromEntity<A extends Aggregate>(Entity entity) {
    return constructAggregateFromEntityRuntime(entity) as A;
  }

  Type getEntityTypeFromAggregate(Type aggregateType) {
    return appRegistration.getEntityTypeFromAggregate(aggregateType);
  }

  TypeStateSerializer getTypeStateSerializerByTypeRuntime(Type type) {
    return appRegistration.getTypeStateSerializerByTypeRuntime(type);
  }

  bool isSubtype(Type a, Type b) {
    return appRegistration.isSubtype(a, b);
  }

  Database get database => appRegistration.database;

  Set<Type> getDescendants(Type type) => appRegistration.getDescendants(type);
}
