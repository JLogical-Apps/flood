import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'default_abstract_local_repository.dart';

class SimpleLocalRepository<E extends Entity<V>, V extends ValueObject> extends DefaultAbstractLocalRepository<E, V> {
  final E Function()? onCreateEntity;
  final V Function()? onCreateValueObject;

  final List<ValueObjectRegistration>? additionalValueObjectRegistrations;
  final List<EntityRegistration>? additionalEntityRegistrations;

  SimpleLocalRepository({
    this.onCreateEntity,
    this.onCreateValueObject,
    this.additionalValueObjectRegistrations,
    this.additionalEntityRegistrations,
  });

  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        if (onCreateValueObject != null) ValueObjectRegistration<V, V?>(onCreateValueObject),
        ...?additionalValueObjectRegistrations,
      ];

  @override
  List<EntityRegistration> get entityRegistrations => [
        if (onCreateEntity != null) EntityRegistration<E, V>(onCreateEntity),
        ...?additionalEntityRegistrations,
      ];
}
