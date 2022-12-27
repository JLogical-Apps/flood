import 'package:example/pond.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/valet_pages_pond_component.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

Future<void> main(List<String> args) async {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PondApp(
      splashPage: StyleProvider(
        style: style,
        child: StyledPage(
          body: Center(
            child: StyledText.h1('Loading'),
          ),
        ),
      ),
      appPondContextGetter: () async {
        final corePondContext = await getCorePondContext(environmentConfig: EnvironmentConfig.static.flutterAssets());
        return await getAppPondContext(corePondContext);
      },
      initialPageGetter: (context, appContext) {
        return StyleguidePage();
      },
    );
  }

  Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
    final appPondContext = AppPondContext(corePondContext: corePondContext);
    await appPondContext.register(EnvironmentBannerAppComponent());
    await appPondContext.register(StyleAppComponent(style: style));
    await appPondContext.register(ValetPagesAppPondComponent());
    return appPondContext;
  }
}
