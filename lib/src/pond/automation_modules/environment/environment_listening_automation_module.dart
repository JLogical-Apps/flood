import '../../automation/automation_context.dart';
import '../../modules/environment/environment.dart';

abstract class EnvironmentListeningAutomationModule {
  Future<void> onEnvironmentChanged(Environment? oldEnvironment, Environment newEnvironment);
}
