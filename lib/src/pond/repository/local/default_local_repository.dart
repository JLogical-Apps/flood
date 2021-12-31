import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';

import '../with_transactions_and_cache_entity_repository.dart';

abstract class DefaultLocalRepository<E extends Entity<V>, V extends ValueObject> = DefaultRepository<E, V>
    with WithLocalEntityRepository, WithTransactionsAndCacheEntityRepository;
