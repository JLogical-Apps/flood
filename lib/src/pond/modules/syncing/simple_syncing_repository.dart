import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_entity_repository_delegator.dart';

import '../../record/entity.dart';
import '../../record/value_object.dart';
import 'syncing_repository.dart';

class SimpleSyncingRepository<E extends Entity<V>, V extends ValueObject> extends SyncingRepository<E, V>
    implements WithEntityRepositoryDelegator {
  @override
  final EntityRepository localRepository;

  @override
  final EntityRepository sourceRepository;

  SimpleSyncingRepository({required this.localRepository, required this.sourceRepository});

  @override
  EntityRepository get entityRepository => localRepository;
}
