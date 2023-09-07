import 'package:release/src/pipeline_step.dart';
import 'package:release/src/steps/version_pipeline_step.dart';

class Pipeline {
  List<PipelineStep> pipelineSteps;

  Pipeline({this.pipelineSteps = const []});

  Pipeline withStep(PipelineStep step) {
    return Pipeline(pipelineSteps: pipelineSteps + [step]);
  }

  Pipeline setVersion() {
    return withStep(VersionPipelineStep());
  }
}
