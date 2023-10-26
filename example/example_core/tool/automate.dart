import 'dart:io';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'),
  );
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  final ignoreBackendPatterns = [
    RegExp('.*node_modules/.*'),
    RegExp('build/.*'),
    RegExp('firebase/.*'),
    RegExp('appwrite/.*'),
    RegExp('tool/.*'),
  ];

  await automatePondContext.register(AppIconAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground_transparent.png',
    backgroundColor: 0x172434,
    padding: 80,
  ));
  await automatePondContext.register(OpsAutomateComponent(environments: {
    EnvironmentType.static.qa: OpsEnvironment.static.appwriteLocal(
      serverFileTemplateGetter: (coreDirectory) => coreDirectory / 'lib' - 'backend.dart',
      ignoreBackendPatterns: ignoreBackendPatterns,
    ),
    EnvironmentType.static.staging: OpsEnvironment.static.appwrite(
      serverFileTemplateGetter: (coreDirectory) => coreDirectory / 'lib' - 'backend.dart',
      ignoreBackendPatterns: ignoreBackendPatterns,
    ),
    EnvironmentType.static.production: OpsEnvironment.static.appwrite(
      serverFileTemplateGetter: (coreDirectory) => coreDirectory / 'lib' - 'backend.dart',
      ignoreBackendPatterns: ignoreBackendPatterns,
    ),
  }));
  await automatePondContext.register(ReleaseAutomateComponent(pipelines: {
    ReleaseEnvironmentType.beta: Pipeline.defaultDeploy({
      ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.internal, isDraft: true),
      ReleasePlatform.ios: DeployTarget.testflight,
      ReleasePlatform.web: DeployTarget.firebase(channel: 'beta'),
    }),
    ReleaseEnvironmentType.production: Pipeline.defaultDeploy({}),
  }));

  await Automate.automate(
    context: automatePondContext,
    args: args,
    appDirectoryGetter: (coreDirectory) => coreDirectory.parent / 'example',
  );
}
