import 'dart:async';

import 'package:environment_core/environment_core.dart';
import 'package:pond_core/pond_core.dart';

class TestingSetupCoreComponent with IsCorePondComponent {
  final FutureOr Function() onSetup;

  TestingSetupCoreComponent({required this.onSetup});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, component) async {
            if (context.environment == EnvironmentType.static.testing) {
              await onSetup();
            }
          },
        ),
      ];
}
