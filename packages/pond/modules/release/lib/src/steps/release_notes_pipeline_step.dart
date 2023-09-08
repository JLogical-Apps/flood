import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class ReleaseNotesPipelineStep with IsPipelineStep {
  @override
  String get name => 'release_notes';

  @override
  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms) async {
    final releaseNotesFile = context.appDirectory / 'build' - 'release_notes.txt';
    final releaseNotesDataSource = DataSource.static.file(releaseNotesFile);
    final previousReleaseNotes = await releaseNotesDataSource.getOrNull();

    var newReleaseNotes = context.input(
      'What would you like to set the release notes to?',
      hintText: previousReleaseNotes ?? '',
    );

    if (newReleaseNotes.isBlank) {
      newReleaseNotes = previousReleaseNotes ?? '';
    }

    await releaseNotesDataSource.set(newReleaseNotes);
  }
}
