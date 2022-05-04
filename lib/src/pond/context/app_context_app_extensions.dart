import 'package:path_provider/path_provider.dart';

import '../modules/core_flutter_module.dart';
import '../modules/core_module.dart';
import '../modules/environment/environment_module.dart';
import 'app_context.dart';
import 'directory/directory_bundle.dart';

extension AppContextAppExtension on AppContext {
  Future<void> registerForTesting() async {
    register(CoreModule());
    register(EnvironmentModule.createForTesting());
  }

  Future<void> registerForApp() async {
    directoryProvider = DirectoryBundle(supportDirectory: await getApplicationSupportDirectory());
    await CoreFlutterModule.initialize(AppContext.global);
  }

  Future<void> registerForWeb() async {
    await CoreFlutterModule.initialize(AppContext.global);
  }
}
