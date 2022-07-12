import 'simple_syncing_repository.dart';
import 'syncing_repository.dart';
import '../../repository/entity_repository.dart';
import '../../record/value_object.dart';
import '../../record/entity.dart';

extension SyncRepositoryExtensions on EntityRepository {
  SyncingRepository asSyncingRepository<E extends Entity<V>, V extends ValueObject>({
    required EntityRepository localRepository,
  }) {
    return SimpleSyncingRepository<E, V>(
      localRepository: localRepository,
      sourceRepository: this,
    );
  }
}
