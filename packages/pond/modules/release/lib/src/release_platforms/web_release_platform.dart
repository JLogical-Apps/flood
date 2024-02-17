import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';

class WebReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'web';

  @override
  Future onBuild(AutomateCommandContext context, ReleaseContext releaseContext) async {
    await context.appProject.run('flutter build web');
  }
}
