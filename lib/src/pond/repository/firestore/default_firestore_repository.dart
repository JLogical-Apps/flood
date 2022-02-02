import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/with_firestore_entity_repository.dart';

import '../with_transactions_and_cache_entity_repository.dart';

abstract class DefaultFirestoreRepository<E extends Entity<V>, V extends ValueObject> extends DefaultRepository<E, V>
    with WithFirestoreEntityRepository, WithTransactionsAndCacheEntityRepository {
  Type get inferredType => E;
}
