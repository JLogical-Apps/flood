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
import '../../query/query.dart';
import '../entity_repository.dart';

abstract class DefaultAbstractAdaptingRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractRepository<E, V> with WithEntityRepositoryDelegator {
  String get dataPath;

  /// The name of the field that stores the union type of
  String get unionTypeFieldName => Query.type;

  /// Converts [type] (the name of a type that extends `E`) to a string to be queried/saved.
  /// The state of extracted documents will find the first [type] in the list of handled types that has the same value.
  String unionTypeConverter(String typeName) {
    return typeName;
  }

  late EntityRepository entityRepository = _getEntityRepository();

  EntityRepository _getEntityRepository() {
    switch (AppContext.global.environment) {
      case Environment.testing:
        return SimpleLocalRepository<E, V>(
          valueObjectRegistrations: valueObjectRegistrations,
          entityRegistrations: entityRegistrations,
          stateInitializer: initializeState,
        );
      case Environment.device:
        return SimpleFileRepository<E, V>(
          dataPath: dataPath,
          valueObjectRegistrations: valueObjectRegistrations,
          entityRegistrations: entityRegistrations,
          stateInitializer: initializeState,
        );
      case Environment.qa:
      case Environment.uat:
      case Environment.alpha:
      case Environment.beta:
      case Environment.production:
        return SimpleFirestoreRepository<E, V>(
          dataPath: dataPath,
          unionTypeFieldName: unionTypeFieldName,
          unionTypeConverterGetter: unionTypeConverter,
          valueObjectRegistrations: valueObjectRegistrations,
          entityRegistrations: entityRegistrations,
          stateInitializer: initializeState,
        );
      default:
        throw UnimplementedError();
    }
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
