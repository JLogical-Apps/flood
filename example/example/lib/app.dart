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
        final appPondContext = AppPondContext(corePondContext: corePondContext);
        await appPondContext.register(EnvironmentBannerAppComponent());
        return appPondContext;
      },
      onFinishedLoading: (context, appContext) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(),
                  body: StyleguideWidget(
                    styleguide: FlatStyle().getStyleguide(),
                  ),
                )));
      },
    );
  }
}
