import 'package:jlogical_utils/src/pond/context/date/date_time_provider.dart';
import 'package:jlogical_utils/src/pond/context/date/with_date_time_delegator.dart';
import 'package:jlogical_utils/src/pond/context/directory/directory_bundle.dart';
import 'package:jlogical_utils/src/pond/context/directory/with_directory_provider_delegetor.dart';
import 'package:jlogical_utils/src/pond/context/factory/app_context_factory.dart'
    if (dart.library.ui) 'package:jlogical_utils/src/pond/context/factory/flutter_app_context_factory.dart'
    if (dart.library.io) 'package:jlogical_utils/src/pond/context/factory/clean_app_context_factory.dart';
import 'package:jlogical_utils/src/pond/context/metadata/context_metadata.dart';
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

  @override
  DateTimeProvider dateTimeProvider = NowDateTimeProvider();

  @override
  DirectoryProvider directoryProvider = DirectoryBundle.empty();

  late ContextMetadata contextMetadata;

  bool get isRelease => contextMetadata.buildType == BuildType.release;

  AppContext._();

  static Future<AppContext> create() async {
    AppContext.global = AppContext._();
    await buildBaseAppContext(AppContext.global);
    return AppContext.global;
  }

  static AppContext createForTesting({DateTime? now}) {
    AppContext.global = AppContext._()..dateTimeProvider = PresetDateTimeProvider(now ?? DateTime.now());
    buildBaseAppContext(AppContext.global);
    return AppContext.global;
  }
}

T locate<T extends Object>() {
  return AppContext.global.locate<T>();
}

T? locateOrNull<T extends Object>() {
  return AppContext.global.locateOrNull<T>();
}
