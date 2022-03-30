import 'package:jlogical_utils/automation.dart';

import '../../modules/environment/environment.dart';

abstract class EnvironmentListeningAutomationModule {
  Future<void> onEnvironmentChanged(AutomationContext context, Environment? oldEnvironment, Environment newEnvironment);
}