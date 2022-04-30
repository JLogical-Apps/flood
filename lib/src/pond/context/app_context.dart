import 'package:jlogical_utils/src/pond/context/date/date_time_provider.dart';
import 'package:jlogical_utils/src/pond/context/date/with_date_time_delegator.dart';
import 'package:jlogical_utils/src/pond/context/directory/directory_bundle.dart';
import 'package:jlogical_utils/src/pond/context/directory/with_directory_provider_delegetor.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_explicit_app_registration.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/database/with_database_delegator.dart';

import 'date/now_date_time_provider.dart';
import 'date/preset_date_time_provider.dart';
import 'directory/directory_provider.dart';

class AppContext
    with WithExplicitAppRegistration, WithDatabaseDelegator, WithDateTimeDelegator, WithDirectoryProviderDelegator
    implements AppRegistration, Database, DateTimeProvider, DirectoryProvider {
  static late AppContext global = AppContext._();

  DateTimeProvider dateTimeProvider = NowDateTimeProvider();

  final DirectoryBundle directoryBundle;

  AppContext._({DirectoryBundle? directoryBundle}) : this.directoryBundle = directoryBundle ?? DirectoryBundle.empty();

  static AppContext createForTesting({DateTime? now}) {
    AppContext.global = AppContext._(directoryBundle: DirectoryBundle.empty())
      ..dateTimeProvider = PresetDateTimeProvider(now ?? DateTime.now());

    return AppContext.global;
  }

  static AppContext createGlobal({DirectoryBundle? directoryBundle}) {
    directoryBundle = directoryBundle ?? DirectoryBundle.empty();
    AppContext.global = AppContext._(directoryBundle: directoryBundle);

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
