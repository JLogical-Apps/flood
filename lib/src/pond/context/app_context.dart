import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';

class AppContext with WithExplicitAppRegistration, WithDatabaseDelegator implements AppRegistration, Database {
  static late AppContext global = AppContext();

  @override
  final Environment environment;

  AppContext({this.environment: Environment.testing});
}

T locate<T extends Object>() {
  return AppContext.global.locate<T>();
}
