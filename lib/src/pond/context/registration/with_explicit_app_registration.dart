import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/module/core_app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/entity_database.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/value_object_type_state_serializer.dart';

import 'entity_registration.dart';

mixin WithExplicitAppRegistration implements AppRegistration {
  final GetIt _getIt = GetIt.asNewInstance();

  Database get database => _entityDatabase;

  final EntityDatabase _entityDatabase = EntityDatabase();

  final List<AppModule> _appModules = [CoreAppModule()];

  List<ValueObjectRegistration> get valueObjectRegistrations =>
      _appModules.expand((module) => module.valueObjectRegistrations).toList();

  List<EntityRegistration> get entityRegistrations =>
      _appModules.expand((module) => module.entityRegistrations).toList();

  List<TypeStateSerializer> get typeStateSerializers =>
      _appModules.expand((module) => module.typeStateSerializers).toList();

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

  void register<T extends Object>(T obj) {
    _getIt.registerSingleton<T>(obj);

    if (obj is AppModule) {
      _appModules.add(obj);
      obj.onRegister(this);
    }

    if (obj is EntityRepository) {
      _entityDatabase.registerRepository(obj);
    }
  }

  T locate<T extends Object>() {
    return _getIt<T>();
  }

  /// Loads all the modules.
  Future<void> load() {
    return Future.wait(_appModules.map((module) => module.onLoad()));
  }

  /// Resets the entire device as if it has never opened the app before.
  Future<void> reset() {
    return Future.wait(_appModules.map((module) => module.onReset()));
  }
}

T locate<T extends Object>() {
  return AppContext.global.locate<T>();
}
