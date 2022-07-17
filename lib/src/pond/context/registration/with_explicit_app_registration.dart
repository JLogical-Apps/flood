import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/entity_database.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

import '../../../utils/export_core.dart';
import 'entity_registration.dart';

mixin WithExplicitAppRegistration implements AppRegistration {
  Map<Type, dynamic> _registrationByType = {};

  Database get database => _entityDatabase;

  final EntityDatabase _entityDatabase = EntityDatabase();

  final List<AppModule> appModules = [];

  List<ValueObjectRegistration> get valueObjectRegistrations =>
      appModules.expand((module) => module.valueObjectRegistrations).toList();

  List<EntityRegistration> get entityRegistrations =>
      appModules.expand((module) => module.entityRegistrations).toList();

  List<TypeStateSerializer> get typeStateSerializers =>
      appModules.expand((module) => module.typeStateSerializers).toList();

  List get navigatorObservers => appModules.expand((module) => module.navigatorObservers).toList();

  Entity? constructEntityRuntimeOrNull(ValueObject initialState) {
    return entityRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == initialState.runtimeType)
        ?.create()
      ?..value = initialState;
  }

  ValueObject? constructValueObjectRuntimeOrNull(Type valueObjectType) {
    return valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType)
        ?.create();
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
      final valueObject = valueObjectRegistration.create();
      valueObject.state = state;

      return valueObject;
    }

    final entityRegistration =
        entityRegistrations.firstWhereOrNull((registration) => registration.entityType.toString() == state.type);
    if (entityRegistration != null) {
      final valueObjectType = entityRegistration.valueObjectType;

      final valueObjectRegistration =
          valueObjectRegistrations.firstWhereOrNull((registration) => registration.valueObjectType == valueObjectType);
      final valueObject = valueObjectRegistration?.create();
      valueObject?.state = state;

      return valueObject;
    }

    return null;
  }

  @override
  TypeStateSerializer getTypeStateSerializerByTypeRuntime(Type type) {
    return typeStateSerializers.firstWhereOrNull((serializer) => serializer.matchesType(type)) ??
        (throw Exception('Unable to find a type state serializer for type [$type]'));
  }

  @override
  TypeStateSerializer getTypeStateSerializerBySerializeValue(dynamic value) {
    return typeStateSerializers.firstWhereOrNull((serializer) => serializer.matchesSerializing(value)) ??
        (throw Exception('Unable to find a type state serializer to serialize value [$value]'));
  }

  @override
  TypeStateSerializer getTypeStateSerializerByDeserializeValue(dynamic value) {
    return typeStateSerializers.firstWhereOrNull((serializer) => serializer.matchesDeserializing(value)) ??
        (throw Exception('Unable to find a type state serializer to deserialize value [$value]'));
  }

  bool isSubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }

    final isValueObject = valueObjectRegistrations
        .any((registration) => registration.valueObjectType == a || registration.nullableValueObjectType == a);
    if (isValueObject) {
      return _isValueObjectSubtype(a, b);
    }

    final isEntity = entityRegistrations.any((registration) => registration.entityType == a);
    if (isEntity) {
      return _isEntitySubtype(a, b);
    }

    return false;
  }

  @override
  Type? getTypeByNameOrNull(String typeName) {
    final valueObjectRegistration = valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.valueObjectType.toString() == typeName);
    if (valueObjectRegistration != null) {
      return valueObjectRegistration.valueObjectType;
    }

    final nullableValueObjectRegistration = valueObjectRegistrations
        .firstWhereOrNull((registration) => registration.nullableValueObjectType.toString() == typeName);
    if (nullableValueObjectRegistration != null) {
      return nullableValueObjectRegistration.valueObjectType;
    }

    final entityRegistration =
        entityRegistrations.firstWhereOrNull((registration) => registration.entityType.toString() == typeName);
    if (entityRegistration != null) {
      return entityRegistration.entityType;
    }

    return null;
  }

  bool _isValueObjectSubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }
    if (b == getRuntimeType<ValueObject?>()) {
      return true;
    }
    if (b == ValueObject && !a.isNullable()) {
      return true;
    }

    final valueObjectRegistrationA = valueObjectRegistrations.firstWhereOrNull(
        (registration) => registration.valueObjectType == a || registration.nullableValueObjectType == a);
    if (valueObjectRegistrationA == null) {
      return false;
    }

    return valueObjectRegistrationA.parents.any((parentType) => _isValueObjectSubtype(parentType, b));
  }

  bool _isEntitySubtype(Type a, Type b) {
    if (a == b) {
      return true;
    }
    if (b == Entity) {
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

  void register<T>(T obj) {
    Object? registerTarget = obj;
    if (obj is AppModule) {
      registerTarget = obj.registerTarget;
    }

    _registrationByType[T] = registerTarget;

    if (registerTarget is AppModule) {
      appModules.add(registerTarget);
      registerTarget.onRegister(this);
    }

    if (registerTarget is EntityRepository) {
      _entityDatabase.registerRepository(registerTarget);
    }
  }

  T? locateOrNull<T>() {
    return _registrationByType[T] as T?;
  }

  /// Loads all the modules.
  Future<void> load() async {
    for (final module in appModules) {
      await module.onLoad(AppContext.global);
    }
  }

  /// Resets the entire device as if it has never opened the app before.
  Future<void> reset() async {
    for (final module in appModules) {
      await module.onReset(AppContext.global);
    }
  }
}
