import 'dart:async';

import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_component.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class BuildPipelineStep with IsPipelineStep {
  final Map<ReleasePlatform, DeployTarget> deployTargetByPlatform;

  BuildPipelineStep({this.deployTargetByPlatform = const {}});

  @override
  String get name => 'build';

  @override
  Future execute(AutomateCommandContext context, ReleaseContext releaseContext) async {
    final releaseComponent = context.automateContext.find<ReleaseAutomateComponent>();

    await context.appProject.run('flutter clean');
    await context.appProject.run('melos bs');
    if (releaseContext.platforms.contains(ReleasePlatform.ios)) {
      await context.appProject.run(
        'pod install',
        workingDirectory: context.appDirectory / 'ios',
      );
    }

    for (final preBuildStep in releaseComponent.preBuildSteps) {
      await preBuildStep.execute(context, releaseContext);
    }

    await doForEachDeployTarget(
      context,
      releaseContext,
      (deployTarget, platform) => deployTarget.preBuild(context, releaseContext, platform),
    );

    for (final platform in releaseContext.platforms) {
      await platform.onBuild(context, releaseContext);
    }

    await doForEachDeployTarget(
      context,
      releaseContext,
      (deployTarget, platform) => deployTarget.postBuild(context, releaseContext, platform),
    );

    for (final postBuildStep in releaseComponent.postBuildSteps) {
      await postBuildStep.execute(context, releaseContext);
    }
  }

  Future<void> doForEachDeployTarget(
    AutomateCommandContext context,
    ReleaseContext releaseContext,
    FutureOr Function(DeployTarget deployTarget, ReleasePlatform platform) action,
  ) async {
    for (final platform in releaseContext.platforms) {
      final deployTarget = deployTargetByPlatform[platform];
      if (deployTarget == null) {
        continue;
      }

      await action(deployTarget, platform);
    }
  }
}
