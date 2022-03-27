import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'default_abstract_file_repository.dart';

class SimpleFileRepository<E extends Entity<V>, V extends ValueObject> extends DefaultAbstractFileRepository<E, V> {
  @override
  final String dataPath;

  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<EntityRegistration> entityRegistrations;

  SimpleFileRepository({
    required this.dataPath,
    required this.valueObjectRegistrations,
    required this.entityRegistrations,
  });
}
