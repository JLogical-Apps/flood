import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_context.dart';

abstract class PipelineStep {
  String get name;

  Future execute(AutomateCommandContext context, ReleaseContext releaseContext);
}

mixin IsPipelineStep implements PipelineStep {}
