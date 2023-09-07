import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_platform.dart';

abstract class PipelineStep {
  String get name;

  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms);
}

mixin IsPipelineStep implements PipelineStep {}
