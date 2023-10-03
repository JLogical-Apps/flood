import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_abstract_repository.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/with_firestore_entity_repository.dart';

import '../with_cache_entity_repository.dart';

abstract class DefaultAbstractFirestoreRepository<E extends Entity<V>,
        V extends ValueObject> = DefaultAbstractRepository<E, V>
    with WithFirestoreEntityRepository, WithCacheEntityRepository;