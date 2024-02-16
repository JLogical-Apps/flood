import 'package:pond_cli/pond_cli.dart';
import 'package:release/release.dart';
import 'package:release/src/deploy_targets/firebase_hosting_deploy_target.dart';
import 'package:release/src/deploy_targets/testflight_deploy_target.dart';
import 'package:release/src/release_context.dart';

abstract class DeployTarget {
  Future onPreBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform);

  Future onPostBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform);

  Future onDeploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform);

  static final DeployTarget testflight = TestflightDeployTarget();

  static DeployTarget googlePlay(GooglePlayTrack track, {bool isDraft = false}) =>
      GooglePlayDeployTarget(track: track, isDraft: isDraft);

  static DeployTarget firebase({String? channel}) => FirebaseHostingDeployTarget(channel: channel);
}

extension DeployTargetExtensions on DeployTarget {
  Future preBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) =>
      onPreBuild(context, releaseContext, platform);

  Future postBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) =>
      onPostBuild(context, releaseContext, platform);

  Future deploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) =>
      onDeploy(context, releaseContext, platform);
}

mixin IsDeployTarget implements DeployTarget {
  @override
  Future onPreBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {}

  @override
  Future onPostBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {}
}
