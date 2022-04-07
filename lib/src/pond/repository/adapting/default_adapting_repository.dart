import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/file/simple_file_repository.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/simple_firestore_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/simple_local_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../../context/registration/entity_registration.dart';
import '../../modules/environment/environment.dart';
import '../entity_repository.dart';

abstract class DefaultAdaptingRepository<E extends Entity<V>, V extends ValueObject> extends DefaultRepository<E, V>
    with WithEntityRepositoryDelegator {
  String get dataPath;

  late EntityRepository entityRepository = getRepository(AppContext.global.environment);

  EntityRepository getRepository(Environment environment) {
    switch (environment) {
      case Environment.testing:
        return getLocalRepository();
      case Environment.device:
        return getFileRepository();
      case Environment.qa:
      case Environment.uat:
      case Environment.alpha:
      case Environment.beta:
      case Environment.production:
        return getFirestoreRepository();
      default:
        throw UnimplementedError();
    }
  }

  EntityRepository getLocalRepository() {
    return SimpleLocalRepository<E, V>(
      valueObjectRegistrations: [ValueObjectRegistration<V, V?>(createValueObject)],
      entityRegistrations: [EntityRegistration<E, V>(createEntity)],
      stateInitializer: initializeState,
    );
  }

  EntityRepository getFileRepository() {
    return SimpleFileRepository<E, V>(
      dataPath: dataPath,
      valueObjectRegistrations: [ValueObjectRegistration<V, V?>(createValueObject)],
      entityRegistrations: [EntityRegistration<E, V>(createEntity)],
      stateInitializer: initializeState,
    );
  }

  EntityRepository getFirestoreRepository() {
    return SimpleFirestoreRepository<E, V>(
      dataPath: dataPath,
      inferredType: E,
      valueObjectRegistrations: [ValueObjectRegistration<V, V?>(createValueObject)],
      entityRegistrations: [EntityRegistration<E, V>(createEntity)],
      stateInitializer: initializeState,
    );
  }

  @override
  Future<void> onLoad(AppContext appContext) {
    return entityRepository.onLoad(appContext);
  }

  @override
  Future<void> onReset(AppContext appContext) {
    return entityRepository.onReset(appContext);
  }
}
