import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<CorePondContext> getCorePondContext({required EnvironmentConfig environmentConfig}) async {
  final corePondContext = CorePondContext();
  await corePondContext.register(EnvironmentConfigModule(environmentConfig: environmentConfig));
  return corePondContext;
}
