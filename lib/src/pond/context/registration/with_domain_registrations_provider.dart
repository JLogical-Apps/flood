import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';

mixin WithDomainRegistrationsProvider<V extends ValueObject, E extends Entity<V>> implements RegistrationsProvider {
  V createValueObject();

  E createEntity();

  AggregateRegistration? get aggregateRegistration => null;

  List<ValueObjectRegistration> get valueObjectRegistrations => [ValueObjectRegistration<V, V?>(createValueObject)];

  List<EntityRegistration> get entityRegistrations => [EntityRegistration<E, V>(createEntity)];

  List<AggregateRegistration> get aggregateRegistrations => [
        if (aggregateRegistration != null) aggregateRegistration!,
      ];

  List<TypeStateSerializer> get additionalTypeStateSerializers => [];
}
