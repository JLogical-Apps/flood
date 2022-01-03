import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_app_registration_delegator.dart';
import 'package:jlogical_utils/src/pond/database/entity_database.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

class DatabaseAppRegistration with WithAppRegistrationDelegator implements AppRegistration {
  final List<EntityRepository> repositories;

  final List<ValueObjectRegistration> additionalValueObjectRegistrations;

  DatabaseAppRegistration({
    required this.repositories,
    this.additionalValueObjectRegistrations: const [],
  });

  late final List<RegistrationsProvider> registrationProviders = repositories
      .where((repository) => repository is RegistrationsProvider)
      .map((repository) => repository as RegistrationsProvider)
      .toList();

  @override
  AppRegistration get appRegistration {
    return ExplicitAppRegistration(
      valueObjectRegistrations:
          registrationProviders.expand((registration) => registration.valueObjectRegistrations).toList() +
              additionalValueObjectRegistrations,
      entityRegistrations: registrationProviders.expand((registration) => registration.entityRegistrations).toList(),
      aggregateRegistrations:
          registrationProviders.expand((registration) => registration.aggregateRegistrations).toList(),
      additionalTypeStateSerializers:
          registrationProviders.expand((registration) => registration.additionalTypeStateSerializers).toList(),
      database: EntityDatabase(repositories: repositories),
    );
  }
}
