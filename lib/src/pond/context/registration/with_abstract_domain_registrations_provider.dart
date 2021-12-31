import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';

mixin WithAbstractDomainRegistrationsProvider<V extends ValueObject, E extends Entity<V>>
    implements RegistrationsProvider {
  List<ValueObjectRegistration> get valueObjectRegistrations;

  List<EntityRegistration> get entityRegistrations;

  List<AggregateRegistration> get aggregateRegistrations => [];

  List<TypeStateSerializer> get additionalTypeStateSerializers => [];
}
