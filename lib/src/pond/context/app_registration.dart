import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class AppRegistration {
  final List<EntityRegistration> entityRegistrations;
  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<AggregateRegistration> aggregateRegistrations;
  final List<TypeStateSerializer> typeStateSerializers;

  AppRegistration({
    this.entityRegistrations: const [],
    this.valueObjectRegistrations: const [],
    this.aggregateRegistrations: const [],
    List<TypeStateSerializer>? additionalTypeStateSerializers,
  }) : typeStateSerializers = [
          ...coreTypeStateSerializers,
          ...nullableCoreTypeStateSerializers,
          ...?additionalTypeStateSerializers,
        ];

  static List<TypeStateSerializer> get coreTypeStateSerializers => [
        IntTypeStateSerializer(),
        DoubleTypeStateSerializer(),
        StringTypeStateSerializer(),
        BoolTypeStateSerializer(),
      ];

  static List<TypeStateSerializer> get nullableCoreTypeStateSerializers => [
        NullableTypeStateSerializer<int?>(IntTypeStateSerializer()),
        NullableTypeStateSerializer<double?>(DoubleTypeStateSerializer()),
        NullableTypeStateSerializer<String?>(StringTypeStateSerializer()),
        NullableTypeStateSerializer<bool?>(BoolTypeStateSerializer()),
      ];

  E constructEntity<E extends Entity<V>, V extends ValueObject>(V initialState) {
    final registration =
        entityRegistrations.firstWhere((registration) => registration.entityType == E) as EntityRegistration<E, V>;
    return registration.create(initialState);
  }

  Entity constructEntityRuntime(Type entityType, ValueObject initialState) {
    final registration = entityRegistrations.firstWhere((registration) => registration.entityType == entityType);
    return registration.create(initialState);
  }

  V constructValueObject<V extends ValueObject>() {
    return valueObjectRegistrations.firstWhere((registration) => registration.valueObjectType == V).onCreate() as V;
  }

  ValueObject constructValueObjectRuntime(Type valueObjectType) {
    return valueObjectRegistrations
        .firstWhere((registration) => registration.valueObjectType == valueObjectType)
        .onCreate();
  }

  ValueObject? constructValueObjectFromStateOrNull(State state) {
    final type = state.type;
    if (type == null) {
      return null;
    }

    final entityRegistration =
        entityRegistrations.firstWhereOrNull((registration) => registration.entityType.toString() == state.type);

    if (entityRegistration == null) {
      return null;
    }

    final valueObjectType = entityRegistration.valueObjectType;

    final valueObjectRegistration =
        valueObjectRegistrations.firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType);
    final valueObject = valueObjectRegistration?.onCreate();
    valueObject?.state = state;

    return valueObject;
  }

  Entity? constructEntityFromStateOrNull(State state) {
    final valueObject = constructValueObjectFromStateOrNull(state);
    if (valueObject == null) {
      return null;
    }

    final entityRegistration =
        entityRegistrations.firstWhereOrNull((registration) => registration.entityType.toString() == state.type);

    final entity = entityRegistration?.create(valueObject);
    entity?.id = state.id;

    return entity;
  }

  Aggregate constructAggregateFromEntityRuntime(Type aggregateType, Entity entity) {
    return aggregateRegistrations
        .firstWhere((registration) => registration.aggregateType == aggregateType)
        .onCreate(entity);
  }

  Type getEntityTypeFromAggregate<A>() {
    return aggregateRegistrations.firstWhere((registration) => registration.aggregateType == A).entityType;
  }

  TypeStateSerializer<T> getTypeStateSerializerByType<T>() {
    return typeStateSerializers.firstWhere((serializer) => serializer.type == T) as TypeStateSerializer<T>;
  }

  TypeStateSerializer getTypeStateSerializerByRuntimeType(Type type) {
    final typeStateSerializer = typeStateSerializers.firstWhereOrNull((serializer) => serializer.type == type);
    if (typeStateSerializer != null) {
      return typeStateSerializer;
    }

    final valueObjectRegistration = valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == type)
        .mapIfNonNull((registration) => RuntimeValueObjectTypeStateSerializer(valueObjectType: type));

    if (valueObjectRegistration != null) {
      return valueObjectRegistration;
    }

    final nullableValueObjectRegistration = valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.nullableValueObjectType == type)
        .mapIfNonNull((registration) => NullableTypeStateSerializer(
            RuntimeValueObjectTypeStateSerializer(valueObjectType: registration.valueObjectType)));

    if (nullableValueObjectRegistration != null) {
      return nullableValueObjectRegistration;
    }

    throw Exception('Unable to find a type state serializer for type [$type]');
  }
}

class EntityRegistration<E extends Entity<V>, V extends ValueObject> {
  final E Function(V initialState) onCreate;

  const EntityRegistration(this.onCreate);

  E create(V initialState) => onCreate(initialState);

  Type get entityType => E;

  Type get valueObjectType => V;
}

class ValueObjectRegistration<V extends ValueObject, NullableV extends ValueObject?> {
  final V Function() onCreate;

  const ValueObjectRegistration(this.onCreate);

  Type get valueObjectType => V;

  Type get nullableValueObjectType => NullableV;
}

class AggregateRegistration<A extends Aggregate<E>, E extends Entity> {
  final A Function(E entity) onCreate;

  const AggregateRegistration(this.onCreate);

  Type get aggregateType => A;

  Type get entityType => E;
}

class RuntimeValueObjectTypeStateSerializer extends TypeStateSerializer<ValueObject> {
  final Type valueObjectType;

  RuntimeValueObjectTypeStateSerializer({required this.valueObjectType});

  @override
  onSerialize(ValueObject value) {
    return value.state.values;
  }

  @override
  ValueObject onDeserialize(dynamic value) {
    return AppContext.global.registration.constructValueObjectRuntime(valueObjectType)
      ..state = State.extractFrom(value)!;
  }
}
