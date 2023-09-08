import 'dart:async';

import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';

class BuildPipelineStep with IsPipelineStep {
  final Map<ReleasePlatform, DeployTarget> deployTargetByPlatform;

  BuildPipelineStep({this.deployTargetByPlatform = const {}});

  @override
  String get name => 'build';

  @override
  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms) async {
    await doForEachDeployTarget(
      context,
      platforms,
      (deployTarget, platform) => deployTarget.preBuild(context, platform),
    );

    for (final platform in platforms) {
      await platform.build(context);
    }

    await doForEachDeployTarget(
      context,
      platforms,
      (deployTarget, platform) => deployTarget.postBuild(context, platform),
    );
  }

  Future<void> doForEachDeployTarget(
    AutomateCommandContext context,
    List<ReleasePlatform> platforms,
    FutureOr Function(DeployTarget deployTarget, ReleasePlatform platform) action,
  ) async {
    for (final platform in platforms) {
      final deployTarget = deployTargetByPlatform[platform];
      if (deployTarget == null) {
        continue;
      }

      await action(deployTarget, platform);
    }
  }
}
