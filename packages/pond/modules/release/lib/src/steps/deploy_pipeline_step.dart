import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';

class DeployPipelineStep with IsPipelineStep {
  final Map<ReleasePlatform, DeployTarget> deployTargetByPlatform;

  DeployPipelineStep({required this.deployTargetByPlatform});

  @override
  String get name => 'deploy';

  @override
  Future execute(AutomateCommandContext context, ReleaseContext releaseContext) async {
    for (final platform in releaseContext.platforms) {
      final deployTarget = deployTargetByPlatform[platform];
      if (deployTarget == null) {
        continue;
      }

      await deployTarget.deploy(context, releaseContext, platform);
    }
  }
}
