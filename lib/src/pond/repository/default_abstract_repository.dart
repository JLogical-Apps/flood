import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

import 'with_id_generator.dart';

abstract class DefaultAbstractRepository<E extends Entity<V>, V extends ValueObject> = EntityRepository
    with WithIdGenerator;
