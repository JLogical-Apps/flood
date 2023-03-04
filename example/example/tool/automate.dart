import 'package:example/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(environmentConfig: EnvironmentConfig.static.fileAssets());
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(AppIconAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground.png',
    backgroundColor: 0x172434,
  ));

  await Automate.automate(context: automatePondContext, args: args);
}
