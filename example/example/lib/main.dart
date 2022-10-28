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
      appContext: AppPondContext(corePondContext: corePondContext)..register(BannerAppComponent()),
    );
  }
}

class BannerAppComponent extends AppPondComponent {
  @override
  Widget wrapApp(Widget app) {
    return Banner(
      message: 'Test!',
      location: BannerLocation.topEnd,
      child: app,
    );
  }
}
