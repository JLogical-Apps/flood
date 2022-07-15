import '../../record/entity.dart';
import '../../record/value_object.dart';
import '../../repository/default_repository.dart';
import '../../repository/with_cache_entity_repository.dart';
import 'with_syncing_repository.dart';

abstract class SyncingRepository<E extends Entity<V>, V extends ValueObject> extends DefaultRepository<E, V>
    with WithSyncingRepository {

  SyncingRepository() {
    sourceRepository.entityInflatedX.listen((entity) {
      localRepository.saveState(entity.state);
    });
  }

  E createEntity() {
    return localRepository.entityRegistrations.firstWhere((registration) => registration.entityType == E).create() as E;
  }

  V createValueObject() {
    return localRepository.valueObjectRegistrations
        .firstWhere((registration) => registration.valueObjectType == V)
        .create() as V;
  }
}
