import 'package:example/pond.dart';
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
      appPondContextGetter: () async {
        final corePondContext = await getCorePondContext(environmentConfig: EnvironmentConfig.static.flutterAssets());
        return await getAppPondContext(corePondContext);
      },
      onFinishedLoading: (context, appContext) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => StyledPage(
                  titleText: 'Styleguide',
                  body: StyleguideWidget(
                    styleguide: appContext.find<StyleAppComponent>().style.getStyleguide(),
                  ),
                )));
      },
    );
  }

  Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
    final appPondContext = AppPondContext(corePondContext: corePondContext);
    await appPondContext.register(EnvironmentBannerAppComponent());
    await appPondContext.register(StyleAppComponent(
        style: FlatStyle(
            // backgroundColor: Color(0xffdedede),
            )));
    return appPondContext;
  }
}
