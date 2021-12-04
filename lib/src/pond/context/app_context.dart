import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_app_registration_delegator.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';
import 'package:jlogical_utils/src/pond/export.dart';

class AppContext with WithAppRegistrationDelegator, WithDatabaseDelegator implements AppRegistration, Database {
  static late AppContext global = AppContext();

  final AppRegistration appRegistration;

  Database get database => appRegistration.database;

  AppContext({
    AppRegistration? registration,
  }) : this.appRegistration = registration ?? ExplicitAppRegistration();
}
