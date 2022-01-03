import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_app_registration_delegator.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';

class AppContext with WithAppRegistrationDelegator, WithDatabaseDelegator implements AppRegistration, Database {
  static late AppContext global = AppContext();

  final AppRegistration appRegistration;

  AppContext({
    AppRegistration? registration,
  }) : this.appRegistration = registration ?? ExplicitAppRegistration();
}
