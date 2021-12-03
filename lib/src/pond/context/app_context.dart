import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_app_registration_delegator.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/export.dart';

class AppContext with WithAppRegistrationDelegator implements AppRegistration {
  static late AppContext global = AppContext();

  final AppRegistration appRegistration;
  final Database database;

  AppContext({
    AppRegistration? registration,
    Database? database,
  })  : this.appRegistration = registration ?? ExplicitAppRegistration(),
        this.database = database ?? Database(repositories: []);
}
