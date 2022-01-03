import 'package:jlogical_utils/src/pond/context/registration/explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

abstract class RegistrationsProvider {
  List<ValueObjectRegistration> get valueObjectRegistrations;

  List<EntityRegistration> get entityRegistrations;

  List<AggregateRegistration> get aggregateRegistrations;

  List<TypeStateSerializer> get additionalTypeStateSerializers;
}
