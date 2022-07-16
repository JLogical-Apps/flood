import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../../context/module/app_module.dart';
import 'syncing_repository.dart';

class SimpleSyncingRepository extends SyncingRepository implements WithEntityRepositoryDelegator {
  @override
  final EntityRepository localRepository;

  @override
  final EntityRepository sourceRepository;

  SimpleSyncingRepository({required this.localRepository, required this.sourceRepository, super.publishOnSave});

  @override
  EntityRepository get entityRepository => localRepository;

  /// Don't register [localRepository], register this.
  @override
  AppModule get registerTarget => this;
}
