import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';

import '../../context/module/app_module.dart';
import 'environment.dart';

/// Module that registers different modules based on the [environment].
abstract class AdaptingModule<T extends AppModule> extends AppModule {
  /// The module to register based on [environment].
  T? getModule(Environment environment);

  @override
  AppModule? get registerTarget => getModule(AppContext.global.environment);

  @override
  Type? get registerTargetType => T;
}
