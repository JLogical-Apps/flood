import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_platform.dart';

class WebReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'web';

  @override
  Future build(AutomateCommandContext context) async {
    await context.appProject.run('flutter build web -t lib/app.dart');
  }
}
