import '../modules/core_module.dart';
import '../modules/environment/environment_module.dart';
import 'app_context.dart';

extension AppContextAppExtension on AppContext {
  void registerForTesting() {
    register(CoreModule());
    register(EnvironmentModule.createForTesting());
  }

  Future<void> registerForApp() async {
    final coreModule = CoreModule();
    await coreModule.initialize(AppContext.global);
  }
}
