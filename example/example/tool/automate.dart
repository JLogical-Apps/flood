import 'package:example/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(environmentConfig: EnvironmentConfig.static.fileAssets());
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(AppIconAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground_transparent.png',
    backgroundColor: 0x172434,
    padding: 80,
  ));

  await Automate.automate(context: automatePondContext, args: args);
}
