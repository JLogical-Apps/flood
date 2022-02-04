import 'package:jlogical_utils/src/pond/context/directory/directory_bundle.dart';
import 'package:jlogical_utils/src/pond/context/directory/with_directory_provider_delegetor.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';

import 'directory/directory_provider.dart';

class AppContext
    with WithExplicitAppRegistration, WithDatabaseDelegator, WithDirectoryProviderDelegator
    implements AppRegistration, Database, DirectoryProvider {
  static late AppContext global = AppContext();

  @override
  final Environment environment;

  final DirectoryBundle directoryBundle;

  AppContext({this.environment: Environment.testing, DirectoryBundle? directoryBundle})
      : this.directoryBundle = directoryBundle ?? DirectoryBundle.empty();

  DirectoryProvider get directoryProvider => directoryBundle;
}

T locate<T extends Object>() {
  return AppContext.global.locate<T>();
}
