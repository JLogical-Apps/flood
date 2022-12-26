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
      initialPageGetter: (context, appContext) {
        return StyleguidePage();
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
    await appPondContext.register(TestAppComponent());
    return appPondContext;
  }
}

class TestAppComponent with IsAppPondComponent {
  @override
  List<AppPage> get pages => [TestPage()];
}

class TestPage extends AppPage {
  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Test',
      body: Center(
        child: StyledContainer(
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.builder().string('test').build();

  @override
  AppPage copy() {
    return TestPage();
  }
}
