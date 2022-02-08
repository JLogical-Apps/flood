import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_abstract_repository.dart';
import 'package:jlogical_utils/src/pond/repository/file/simple_file_repository.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/simple_firestore_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/simple_local_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../../modules/environment/environment.dart';
import '../entity_repository.dart';

abstract class DefaultAbstractAdaptingRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractRepository<E, V> with WithEntityRepositoryDelegator {
  String get dataPath;

  late EntityRepository entityRepository = _getEntityRepository();

  EntityRepository _getEntityRepository() {
    switch (AppContext.global.environment) {
      case Environment.testing:
        return SimpleLocalRepository<E, V>(
          additionalValueObjectRegistrations: valueObjectRegistrations,
          additionalEntityRegistrations: entityRegistrations,
        );
      case Environment.device:
        return SimpleFileRepository<E, V>(
          dataPath: dataPath,
          additionalValueObjectRegistrations: valueObjectRegistrations,
          additionalEntityRegistrations: entityRegistrations,
        );
      case Environment.qa:
      case Environment.uat:
      case Environment.alpha:
      case Environment.beta:
      case Environment.production:
        return SimpleFirestoreRepository<E, V>(
          dataPath: dataPath,
          additionalValueObjectRegistrations: valueObjectRegistrations,
          additionalEntityRegistrations: entityRegistrations,
        );
      default:
        throw UnimplementedError();
    }
  }
}
