import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

import 'with_id_generator.dart';
import 'with_mono_entity_repository.dart';

abstract class DefaultRepository<E extends Entity<V>, V extends ValueObject> extends EntityRepository
    with WithMonoEntityRepository<E>, WithIdGenerator {
  V createValueObject();

  E createEntity();

  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [ValueObjectRegistration<V, V?>(createValueObject)];

  @override
  List<EntityRegistration> get entityRegistrations => [EntityRegistration<E, V>(createEntity)];
}
