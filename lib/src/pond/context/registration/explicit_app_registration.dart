import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class ExplicitAppRegistration implements AppRegistration {
  final List<EntityRegistration> entityRegistrations;
  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<AggregateRegistration> aggregateRegistrations;
  final List<TypeStateSerializer> typeStateSerializers;

  ExplicitAppRegistration({
    this.entityRegistrations: const [],
    this.valueObjectRegistrations: const [],
    this.aggregateRegistrations: const [],
    List<TypeStateSerializer>? additionalTypeStateSerializers,
  }) : typeStateSerializers = [
          ..._coreTypeStateSerializers,
          ..._nullableCoreTypeStateSerializers,
          ...?additionalTypeStateSerializers,
        ];

  static List<TypeStateSerializer> get _coreTypeStateSerializers => [
        IntTypeStateSerializer(),
        DoubleTypeStateSerializer(),
        StringTypeStateSerializer(),
        BoolTypeStateSerializer(),
      ];

  static List<TypeStateSerializer> get _nullableCoreTypeStateSerializers => [
        NullableTypeStateSerializer<int?>(IntTypeStateSerializer()),
        NullableTypeStateSerializer<double?>(DoubleTypeStateSerializer()),
        NullableTypeStateSerializer<String?>(StringTypeStateSerializer()),
        NullableTypeStateSerializer<bool?>(BoolTypeStateSerializer()),
      ];

  Entity? constructEntityRuntimeOrNull(ValueObject initialState) {
    return entityRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == initialState.runtimeType)
        ?.create(initialState);
  }

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType) {
    return valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType)
        ?.onCreate();
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

  Aggregate? constructAggregateFromEntityRuntimeOrNull(Entity entity) {
    final entityType = entity.runtimeType;
    return aggregateRegistrations
        .firstWhereOrNull((registration) => registration.entityType == entityType)
        ?.onCreate(entity);
  }

  Entity? constructEntityFromStateOrNull(State state) {

  }

  Type getEntityTypeFromAggregate(Type aggregateType) {
    return aggregateRegistrations
            .firstWhereOrNull((registration) => registration.aggregateType == aggregateType)
            ?.entityType ??
        (throw Exception('Could not find aggregate with type [$aggregateType]'));
  }

  TypeStateSerializer getTypeStateSerializerByTypeRuntime(Type type) {
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
    return AppContext.global.appRegistration.constructValueObjectRuntime(valueObjectType)
      ..state = State.extractFrom(value)!;
  }
}
