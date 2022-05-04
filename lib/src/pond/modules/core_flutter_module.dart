import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/modules/config/config_module.dart';

import '../context/registration/app_registration.dart';
import 'config/config_module.dart';
import 'core_module.dart';
import 'environment/environment_module.dart';

class CoreFlutterModule extends AppModule {
  CoreFlutterModule._();

  static Future<void> initialize(AppRegistration registration) async {
    registration.register(await ConfigModule.create());
    registration.register(await EnvironmentModule.create());
    registration.register(CoreModule());
  }
}
