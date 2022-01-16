import 'dart:io';

import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/context/registration/explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_abstract_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../entity_repository.dart';
import '../file/default_abstract_file_repository.dart';
import '../local/default_abstract_local_repository.dart';

abstract class DefaultAbstractAdaptingRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractRepository<E, V> with WithEntityRepositoryDelegator {
  Directory get baseDirectory;

  late EntityRepository entityRepository = _getEntityRepository();

  EntityRepository _getEntityRepository() {
    switch (AppContext.global.environment) {
      case Environment.testing:
        return _DefaultAbstractLocalRepository<E, V>(
          valueObjectRegistrations: valueObjectRegistrations,
          entityRegistrations: entityRegistrations,
        );
      case Environment.local:
        return _DefaultAbstractFileRepository<E, V>(
          baseDirectory: baseDirectory,
          valueObjectRegistrations: valueObjectRegistrations,
          entityRegistrations: entityRegistrations,
        );
      default:
        throw UnimplementedError();
    }
  }
}

class _DefaultAbstractLocalRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractLocalRepository<E, V> {
  @override
  final List<ValueObjectRegistration> valueObjectRegistrations;

  @override
  final List<EntityRegistration> entityRegistrations;

  _DefaultAbstractLocalRepository({required this.valueObjectRegistrations, required this.entityRegistrations});
}

class _DefaultAbstractFileRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractFileRepository<E, V> {
  @override
  final List<ValueObjectRegistration> valueObjectRegistrations;

  @override
  final List<EntityRegistration> entityRegistrations;

  @override
  final Directory baseDirectory;

  _DefaultAbstractFileRepository({
    required this.baseDirectory,
    required this.valueObjectRegistrations,
    required this.entityRegistrations,
  });
}
