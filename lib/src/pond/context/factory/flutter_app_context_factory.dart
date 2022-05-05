import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/src/pond/modules/config/app_config_module.dart';
import 'package:path_provider/path_provider.dart';

import '../../modules/config/config_module.dart';
import '../../modules/core_module.dart';
import '../../modules/environment/environment_module.dart';
import '../app_context.dart';
import '../directory/directory_bundle.dart';
import '../metadata/context_metadata.dart';

Future<void> buildBaseAppContext(AppContext context) async {
  context.contextMetadata = ContextMetadata(buildType: BuildType.debug);
  context.register(CoreModule());

  final isTest = Platform.environment.containsKey('FLUTTER_TEST');
  final isWeb = kIsWeb;

  if (isTest) {
    context.register(EnvironmentModule.createForTesting());
  } else if (isWeb) {
    context.register<ConfigModule>(await AppConfigModule.create());
    context.register(await EnvironmentModule.create());
  } else {
    context.directoryProvider = DirectoryBundle(supportDirectory: await getApplicationSupportDirectory());
    context.register<ConfigModule>(await AppConfigModule.create());
    context.register(await EnvironmentModule.create());
  }
}
