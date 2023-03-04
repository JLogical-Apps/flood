import 'dart:async';

import 'package:environment/environment.dart';
import 'package:pond/pond.dart';

class TestingSetupAppComponent with IsAppPondComponent {
  final FutureOr Function() onSetup;

  TestingSetupAppComponent({required this.onSetup});

  @override
  Future onLoad(AppPondContext context) async {
    if (context.environment == EnvironmentType.static.testing) {
      await onSetup();
    }
  }
}
