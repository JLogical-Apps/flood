import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/entity_database.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/value_object_type_state_serializer.dart';

class ExplicitAppRegistration implements AppRegistration {
  final List<EntityRegistration> entityRegistrations;
  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<AggregateRegistration> aggregateRegistrations;
  final List<TypeStateSerializer> typeStateSerializers;
  final Database database;

  ExplicitAppRegistration({
    this.entityRegistrations: const [],
    this.valueObjectRegistrations: const [],
    this.aggregateRegistrations: const [],
    Database? database,
    List<TypeStateSerializer>? additionalTypeStateSerializers,
  })  : typeStateSerializers = [
          ..._coreTypeStateSerializers,
          ..._nullableCoreTypeStateSerializers,
          ...?additionalTypeStateSerializers,
        ],
        this.database = database ?? EntityDatabase(repositories: []);

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
        ?.create()
      ?..value = initialState;
  }

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType) {
    return valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType)
        ?.onCreate!();
  }

  ValueObject? constructValueObjectFromStateOrNull(State state) {
    final type = state.type;
    if (type == null) {
      return null;
    }

    final valueObjectRegistration = valueObjectRegistrations.firstWhereOrNull((registration) =>
        registration.valueObjectType.toString() == state.type ||
        registration.nullableValueObjectType.toString() == state.type);
    if (valueObjectRegistration != null) {
      final valueObject = valueObjectRegistration.onCreate!();
      valueObject.state = state;

      return valueObject;
    }

    final entityRegistration =
        entityRegistrations.firstWhereOrNull((registration) => registration.entityType.toString() == state.type);
    if (entityRegistration != null) {
      final valueObjectType = entityRegistration.valueObjectType;

      final valueObjectRegistration =
          valueObjectRegistrations.firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType);
      final valueObject = valueObjectRegistration?.onCreate!();
      valueObject?.state = state;

      return valueObject;
    }

    return null;
  }

  Aggregate? constructAggregateFromEntityRuntimeOrNull(Entity entity) {
    final entityType = entity.runtimeType;
    return aggregateRegistrations
        .firstWhereOrNull((registration) => registration.entityType == entityType)
        ?.create(entity);
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

    final hasValueObjectRegistration =
        valueObjectRegistrations.any((registration) => registration.valueObjectType == type);

    if (hasValueObjectRegistration) {
      return ValueObjectTypeStateSerializer();
    }

    final hasNullableValueObjectRegistration =
        valueObjectRegistrations.any((registration) => registration.nullableValueObjectType == type);
    if (hasNullableValueObjectRegistration) {
      return NullableTypeStateSerializer(ValueObjectTypeStateSerializer());
    }

    throw Exception('Unable to find a type state serializer for type [$type]');
  }

  bool isSubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }

    final isValueObject = valueObjectRegistrations.any((registration) => registration.valueObjectType == a);
    if (isValueObject) {
      return _isValueObjectSubtype(a, b);
    }

    final isEntity = entityRegistrations.any((registration) => registration.entityType == a);
    if (isEntity) {
      return _isEntitySubtype(a, b);
    }

    return false;
  }

  bool _isValueObjectSubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }

    final valueObjectRegistrationA =
        valueObjectRegistrations.firstWhereOrNull((registration) => registration.valueObjectType == a);
    if (valueObjectRegistrationA == null) {
      return false;
    }

    return valueObjectRegistrationA.parents.any((parentType) => _isValueObjectSubtype(parentType, b));
  }

  bool _isEntitySubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }

    final entityRegistrationA = entityRegistrations.firstWhereOrNull((registration) => registration.entityType == a);
    if (entityRegistrationA == null) {
      return false;
    }

    final valueObjectTypeA = entityRegistrationA.valueObjectType;

    final valueObjectRegistrationA =
        valueObjectRegistrations.firstWhere((registration) => registration.valueObjectType == valueObjectTypeA);

    final parentEntityRegistrations = valueObjectRegistrationA.parents
        .map((parentType) =>
            entityRegistrations.firstWhereOrNull((registration) => registration.valueObjectType == parentType))
        .where((registration) => registration != null)
        .map((registration) => registration!)
        .toList();

    return parentEntityRegistrations.any((registration) => _isEntitySubtype(registration.entityType, b));
  }

  Set<Type> getDescendants(Type type) {
    final isEntity = entityRegistrations.any((registration) => registration.entityType == type);
    if (isEntity) {
      final entityValueType = _getEntityValueTypeOrNull(type)!;
      final valueObjectDescendants = {entityValueType};
      var changed = true;
      while (changed) {
        changed = entityRegistrations
            .map((registration) => registration.valueObjectType)
            .map((type) => valueObjectRegistrations.firstWhere((registration) => registration.valueObjectType == type))
            .where((registration) => registration.parents.any((parent) => valueObjectDescendants.contains(parent)))
            .map((registration) => valueObjectDescendants.add(registration.valueObjectType))
            .any((added) => added);
      }

      valueObjectDescendants.remove(entityValueType); // The type itself is not a descendant.

      final entityDescendants = valueObjectDescendants
          .map((type) => _getValueObjectWrapperEntityTypeOrNull(type))
          .where((type) => type != null)
          .map((type) => type!)
          .toSet();

      return entityDescendants;
    }

    throw Exception('Unable to get descendants of type [$type]');
  }

  Type? _getEntityValueTypeOrNull(Type entityType) {
    return entityRegistrations
        .firstWhereOrNull((registration) => registration.entityType == entityType)
        ?.valueObjectType;
  }

  Type? _getValueObjectWrapperEntityTypeOrNull(Type valueObjectType) {
    return entityRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType)
        ?.entityType;
  }
}

class EntityRegistration<E extends Entity<V>, V extends ValueObject> {
  final E Function()? onCreate;

  const EntityRegistration(this.onCreate);

  const EntityRegistration.abstract() : onCreate = null;

  E create() => onCreate!();

  bool get isAbstract => onCreate == null;

  Type get entityType => E;

  Type get valueObjectType => V;
}

class ValueObjectRegistration<V extends ValueObject, NullableV extends ValueObject?> {
  final V Function()? onCreate;

  final Set<Type> parents;

  bool get isAbstract => onCreate == null;

  ValueObjectRegistration(this.onCreate, {Set<Type>? parents})
      : this.parents = {
          ...?parents,
          ..._baseParentTypes,
        };

  ValueObjectRegistration.abstract({Set<Type>? parents})
      : this.parents = {
          ...?parents,
          ..._baseParentTypes,
        },
        onCreate = null;

  Type get valueObjectType => V;

  Type get nullableValueObjectType => NullableV;

  static Set<Type> get _baseParentTypes => {ValueObject, Record};
}

class AggregateRegistration<A extends Aggregate<E>, E extends Entity> {
  final A Function(E entity) onCreate;

  const AggregateRegistration(this.onCreate);

  A create(E entity) => onCreate(entity);

  Type get aggregateType => A;

  Type get entityType => E;
}
