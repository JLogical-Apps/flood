import 'dart:io';

import 'package:example_core/example_core.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(
      environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'));
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(AppIconAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground_transparent.png',
    backgroundColor: 0x172434,
    padding: 80,
  ));
  await automatePondContext.register(OpsAutomateComponent(environments: {
    EnvironmentType.static.qa: OpsEnvironment.static.firebaseEmulator,
    EnvironmentType.static.staging: OpsEnvironment.static.firebaseEmulator,
  }));

  await Automate.automate(context: automatePondContext, args: args);
}
