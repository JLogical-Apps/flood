import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_app_registration_delegator.dart';

class DatabaseAppRegistration with WithAppRegistrationDelegator implements AppRegistration {
  final List<EntityRepository> repositories;

  DatabaseAppRegistration({required this.repositories});

  late final List<RegistrationsProvider> registrationProviders = repositories
      .where((repository) => repository is RegistrationsProvider)
      .map((repository) => repository as RegistrationsProvider)
      .toList();

  @override
  AppRegistration get appRegistration {
    return ExplicitAppRegistration(
      valueObjectRegistrations:
          registrationProviders.expand((registration) => registration.valueObjectRegistrations).toList(),
      entityRegistrations: registrationProviders.expand((registration) => registration.entityRegistrations).toList(),
      aggregateRegistrations:
          registrationProviders.expand((registration) => registration.aggregateRegistrations).toList(),
      additionalTypeStateSerializers:
          registrationProviders.expand((registration) => registration.additionalTypeStateSerializers).toList(),
      database: EntityDatabase(repositories: repositories),
    );
  }
}
