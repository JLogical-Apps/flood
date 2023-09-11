import 'package:pond_cli/pond_cli.dart';
import 'package:release/release.dart';
import 'package:release/src/deploy_targets/firebase_hosting_deploy_target.dart';
import 'package:release/src/deploy_targets/testflight_deploy_target.dart';

abstract class DeployTarget {
  Future onPreBuild(AutomateCommandContext context, ReleasePlatform platform);

  Future onPostBuild(AutomateCommandContext context, ReleasePlatform platform);

  Future onDeploy(AutomateCommandContext context, ReleasePlatform platform);

  static final DeployTarget testflight = TestflightDeployTarget();

  static DeployTarget googlePlay(GooglePlayTrack track, {bool isDraft = false}) =>
      GooglePlayDeployTarget(track: track, isDraft: isDraft);

  static DeployTarget firebase({String? channel}) => FirebaseHostingDeployTarget(channel: channel);
}

extension DeployTargetExtensions on DeployTarget {
  Future preBuild(AutomateCommandContext context, ReleasePlatform platform) => onPreBuild(context, platform);

  Future postBuild(AutomateCommandContext context, ReleasePlatform platform) => onPostBuild(context, platform);

  Future deploy(AutomateCommandContext context, ReleasePlatform platform) => onDeploy(context, platform);
}

mixin IsDeployTarget implements DeployTarget {
  @override
  Future onPreBuild(AutomateCommandContext context, ReleasePlatform platform) async {}

  @override
  Future onPostBuild(AutomateCommandContext context, ReleasePlatform platform) async {}
}
