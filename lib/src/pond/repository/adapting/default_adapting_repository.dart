import 'dart:io';

import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../entity_repository.dart';
import '../file/default_file_repository.dart';
import '../local/default_local_repository.dart';

abstract class DefaultAdaptingRepository<E extends Entity<V>, V extends ValueObject> extends DefaultRepository<E, V>
    with WithEntityRepositoryDelegator {
  Directory get baseDirectory;

  late EntityRepository entityRepository = _getEntityRepository();

  EntityRepository _getEntityRepository() {
    switch (AppContext.global.environment) {
      case Environment.testing:
        return _DefaultLocalRepository(
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      case Environment.local:
        return _DefaultFileRepository(
          baseDirectory: baseDirectory,
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      default:
        throw UnimplementedError();
    }
  }
}

class _DefaultLocalRepository<E extends Entity<V>, V extends ValueObject> extends DefaultLocalRepository<E, V> {
  final E Function() onCreateEntity;
  final V Function() onCreateValueObject;

  _DefaultLocalRepository({required this.onCreateEntity, required this.onCreateValueObject});

  @override
  E createEntity() => onCreateEntity();

  @override
  V createValueObject() => onCreateValueObject();
}

class _DefaultFileRepository<E extends Entity<V>, V extends ValueObject> extends DefaultFileRepository<E, V> {
  final E Function() onCreateEntity;
  final V Function() onCreateValueObject;

  @override
  final Directory baseDirectory;

  _DefaultFileRepository({
    required this.baseDirectory,
    required this.onCreateEntity,
    required this.onCreateValueObject,
  });

  @override
  E createEntity() => onCreateEntity();

  @override
  V createValueObject() => onCreateValueObject();
}
