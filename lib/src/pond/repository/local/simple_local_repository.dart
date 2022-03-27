import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'default_abstract_local_repository.dart';

class SimpleLocalRepository<E extends Entity<V>, V extends ValueObject> extends DefaultAbstractLocalRepository<E, V> {
  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<EntityRegistration> entityRegistrations;

  SimpleLocalRepository({
    required this.valueObjectRegistrations,
    required this.entityRegistrations,
  });
}
