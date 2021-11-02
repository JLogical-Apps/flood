import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class AppContext {
  static late AppContext global = AppContext();

  final List<EntityRegistration> entityRegistrations;
  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<TypeStateSerializer> typeStateSerializers;

  AppContext({
    this.entityRegistrations: const [],
    this.valueObjectRegistrations: const [],
    List<TypeStateSerializer>? typeStateSerializers,
  }) : this.typeStateSerializers = typeStateSerializers ?? defaultTypeStateSerializerProviders;

  E constructEntity<E extends Entity>() {
    return entityRegistrations.firstWhere((registration) => registration.entityType == E).onCreate() as E;
  }

  V constructValueObject<V extends ValueObject>() {
    return valueObjectRegistrations.firstWhere((registration) => registration.valueObjectType == V).onCreate() as V;
  }

  TypeStateSerializer<T> getTypeStateSerializerByType<T>() {
    return typeStateSerializers.firstWhere((serializer) => serializer.type == T) as TypeStateSerializer<T>;
  }

  static List<TypeStateSerializer> get defaultTypeStateSerializerProviders => [
        IntTypeStateSerializer(),
        StringTypeStateSerializer(),
        BoolTypeStateSerializer(),
      ];
}

class EntityRegistration<E extends Entity> {
  final E Function() onCreate;

  const EntityRegistration(this.onCreate);

  Type get entityType => E;
}

class ValueObjectRegistration<V extends ValueObject> {
  final V Function() onCreate;

  const ValueObjectRegistration(this.onCreate);

  Type get valueObjectType => V;
}
