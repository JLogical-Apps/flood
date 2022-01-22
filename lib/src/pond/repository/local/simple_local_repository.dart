import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'default_local_repository.dart';

class SimpleLocalRepository<E extends Entity<V>, V extends ValueObject> extends DefaultLocalRepository<E, V> {
  final E Function() onCreateEntity;
  final V Function() onCreateValueObject;

  SimpleLocalRepository({required this.onCreateEntity, required this.onCreateValueObject});

  @override
  E createEntity() => onCreateEntity();

  @override
  V createValueObject() => onCreateValueObject();
}
