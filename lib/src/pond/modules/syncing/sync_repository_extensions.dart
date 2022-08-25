import 'package:flutter/foundation.dart';

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

  SyncingRepository asWebAdaptingSyncingRepository({
    required EntityRepository fileRepository,
    required EntityRepository localRepository,
    bool publishOnSave: true,
  }) {
    return SimpleSyncingRepository(
      localRepository: kIsWeb ? localRepository : fileRepository,
      sourceRepository: this,
      publishOnSave: publishOnSave,
    );
  }
}
