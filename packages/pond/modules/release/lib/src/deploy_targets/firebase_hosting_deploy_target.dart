import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseHostingDeployTarget with IsDeployTarget {
  final String? channel;

  FirebaseHostingDeployTarget({this.channel});

  @override
  Future onDeploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {
    final firebaseHostingDirectory = context.coreDirectory / 'firebase' / 'public';
    final webBuildDirectory = context.appDirectory / 'build' / 'web';

    await DataSource.static.directory(firebaseHostingDirectory).delete();
    await webBuildDirectory.copyTo(firebaseHostingDirectory);

    final command = channel == null ? 'firebase deploy --only hosting' : 'firebase hosting:channel:deploy $channel';
    await context.run(
      command,
      workingDirectory: context.coreDirectory / 'firebase',
    );
  }
}
