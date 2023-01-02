import 'package:example/pond.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/valet_pages_pond_component.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

late AppPondContext appPondContext;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    appPondContext:
        await getAppPondContext(await getCorePondContext(environmentConfig: EnvironmentConfig.static.flutterAssets())),
  ));
}

class App extends StatelessWidget {
  final AppPondContext appPondContext;

  const App({super.key, required this.appPondContext});

  @override
  Widget build(BuildContext context) {
    return PondApp(
      splashPage: StyledPage(
        body: Center(
          child: StyledLoadingIndicator(),
        ),
      ),
      notFoundPage: StyledPage(
        body: Center(
          child: StyledText.h1('Not Found!'),
        ),
      ),
      appPondContext: appPondContext,
      initialPageGetter: () {
        return StyleguidePage();
      },
    );
  }
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(NavigationAppPondComponent());
  await appPondContext.register(EnvironmentBannerAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(ModelAppComponent(
      modelBuilderConfig: ModelBuilderConfig(
    loadingIndicator: StyledLoadingIndicator(),
    errorBuilder: (error, stack) => StyledText.body.error('$error\n$stack'),
  )));
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(ValetPagesAppPondComponent());
  return appPondContext;
}
