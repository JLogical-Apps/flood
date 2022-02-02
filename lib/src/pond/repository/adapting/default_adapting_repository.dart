import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/file/simple_file_repository.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/simple_firestore_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/simple_local_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../entity_repository.dart';

abstract class DefaultAdaptingRepository<E extends Entity<V>, V extends ValueObject> extends DefaultRepository<E, V>
    with WithEntityRepositoryDelegator {
  String get dataPath;

  late EntityRepository entityRepository = getRepository(AppContext.global.environment);

  EntityRepository getRepository(Environment environment) {
    switch (environment) {
      case Environment.testing:
        return SimpleLocalRepository<E, V>(
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      case Environment.device:
        return SimpleFileRepository<E, V>(
          dataPath: dataPath,
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      case Environment.qa:
      case Environment.uat:
      case Environment.alpha:
      case Environment.beta:
      case Environment.production:
        return SimpleFirestoreRepository<E, V>(
          dataPath: dataPath,
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      default:
        throw UnimplementedError();
    }
  }
}
