import '../../repository/entity_repository.dart';
import 'simple_syncing_repository.dart';
import 'syncing_repository.dart';

extension SyncRepositoryExtensions on EntityRepository {
  SyncingRepository asSyncingRepository({
    required EntityRepository localRepository,
    bool publishOnSave: true,
  }) {
    return SimpleSyncingRepository(
      localRepository: localRepository,
      sourceRepository: this,
      publishOnSave: publishOnSave,
    );
  }
}
