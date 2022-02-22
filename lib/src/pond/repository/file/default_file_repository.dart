import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/default_repository.dart';
import 'package:jlogical_utils/src/pond/repository/file/with_file_entity_repository.dart';

import '../with_cache_entity_repository.dart';

abstract class DefaultFileRepository<E extends Entity<V>, V extends ValueObject> = DefaultRepository<E, V>
    with WithFileEntityRepository, WithCacheEntityRepository;
