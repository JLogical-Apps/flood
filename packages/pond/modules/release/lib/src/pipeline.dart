import 'package:release/src/deploy_target.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';
import 'package:release/src/steps/build_pipeline_step.dart';
import 'package:release/src/steps/deploy_pipeline_step.dart';
import 'package:release/src/steps/release_notes_pipeline_step.dart';
import 'package:release/src/steps/test_pipeline_step.dart';
import 'package:release/src/steps/version_pipeline_step.dart';

class Pipeline {
  List<PipelineStep> pipelineSteps;

  Pipeline({this.pipelineSteps = const []});

  static Pipeline defaultDeploy(Map<ReleasePlatform, DeployTarget> deployTargetByPlatform) {
    return Pipeline().version().releaseNotes().test().build(deployTargetByPlatform).deploy(deployTargetByPlatform);
  }

  Pipeline withStep(PipelineStep step) {
    return Pipeline(pipelineSteps: pipelineSteps + [step]);
  }

  Pipeline version() {
    return withStep(VersionPipelineStep());
  }

  Pipeline releaseNotes() {
    return withStep(ReleaseNotesPipelineStep());
  }

  Pipeline build([Map<ReleasePlatform, DeployTarget> deployTargetByPlatform = const {}]) {
    return withStep(BuildPipelineStep(deployTargetByPlatform: deployTargetByPlatform));
  }

  Pipeline test() {
    return withStep(TestPipelineStep());
  }

  Pipeline deploy(Map<ReleasePlatform, DeployTarget> deployTargetByPlatform) {
    return withStep(DeployPipelineStep(deployTargetByPlatform: deployTargetByPlatform));
  }
}
