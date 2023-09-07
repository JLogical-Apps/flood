import 'package:release/src/deploy_target.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';
import 'package:release/src/steps/test_pipeline_step.dart';
import 'package:release/src/steps/version_pipeline_step.dart';

class Pipeline {
  List<PipelineStep> pipelineSteps;

  Pipeline({this.pipelineSteps = const []});

  static Pipeline defaultDeploy(Map<ReleasePlatform, DeployTarget> deployTargets) {
    return Pipeline().setVersion().test();
  }

  Pipeline withStep(PipelineStep step) {
    return Pipeline(pipelineSteps: pipelineSteps + [step]);
  }

  Pipeline setVersion() {
    return withStep(VersionPipelineStep());
  }

  Pipeline test() {
    return withStep(TestPipelineStep());
  }
}
