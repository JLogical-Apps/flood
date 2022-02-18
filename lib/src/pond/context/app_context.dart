import 'package:jlogical_utils/src/pond/context/directory/directory_bundle.dart';
import 'package:jlogical_utils/src/pond/context/directory/with_directory_provider_delegetor.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';

import '../modules/core_module.dart';
import 'directory/directory_provider.dart';

class AppContext
    with WithExplicitAppRegistration, WithDatabaseDelegator, WithDirectoryProviderDelegator
    implements AppRegistration, Database, DirectoryProvider {
  static late AppContext global = AppContext();

  final DirectoryBundle directoryBundle;

  AppContext({DirectoryBundle? directoryBundle}) : this.directoryBundle = directoryBundle ?? DirectoryBundle.empty();

  static Future<AppContext> createForTesting() async {
    AppContext.global = AppContext(directoryBundle: DirectoryBundle.empty())..register(CoreModule());

    return AppContext.global;
  }

  static Future<AppContext> createGlobal() async {
    AppContext.global = AppContext(directoryBundle: await DirectoryBundle.generate());

    final coreModule = CoreModule();
    await coreModule.initialize(AppContext.global);

    return AppContext.global;
  }

  DirectoryProvider get directoryProvider => directoryBundle;
}

T locate<T extends Object>() {
  return AppContext.global.locate<T>();
}

T? locateOrNull<T extends Object>() {
  return AppContext.global.locateOrNull<T>();
}
