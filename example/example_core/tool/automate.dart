import 'dart:io';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'),
  );
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(NativeSetupAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground.png',
    backgroundColor: 0xffffff,
    padding: 100,
  ));
  await automatePondContext.register(OpsAutomateComponent(environments: {
    EnvironmentType.static.qa: OpsEnvironment.static.firebaseEmulator,
    EnvironmentType.static.staging: OpsEnvironment.static.firebase,
    EnvironmentType.static.production: OpsEnvironment.static.firebase,
  }));
  await automatePondContext.register(ReleaseAutomateComponent(
    screenshotsDirectoryGetter: (fileSystem) => fileSystem.appDirectory / 'screenshots',
    pipelines: {
      ReleaseEnvironmentType.production: Pipeline.defaultDeploy({
        ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.beta),
        ReleasePlatform.ios: DeployTarget.testflight,
        ReleasePlatform.web: DeployTarget.firebase(),
      }),
      ReleaseEnvironmentType.beta: Pipeline.defaultDeploy({
        ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.internal, isDraft: true),
        ReleasePlatform.ios: DeployTarget.testflight,
        ReleasePlatform.web: DeployTarget.firebase(channel: 'beta'),
      }),
    },
    appStoreDeployTargetByPlatform: {
      ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.beta),
      ReleasePlatform.ios: DeployTarget.appStore,
    },
  ));

  await Automate.automate(
    context: automatePondContext,
    args: args,
    appDirectoryGetter: (coreDirectory) => coreDirectory.parent / 'example',
  );
}
