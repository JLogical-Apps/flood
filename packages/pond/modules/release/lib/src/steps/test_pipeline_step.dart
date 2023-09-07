import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';

class TestPipelineStep with IsPipelineStep {
  @override
  String get name => 'test';

  @override
  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms) async {
    for (final project in context.projects) {
      if (await project.testDirectory.exists()) {
        await project.run('${project.executableRoot} test');
      }
    }
  }
}
