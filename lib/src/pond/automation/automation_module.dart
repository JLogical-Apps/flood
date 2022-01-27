import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:jlogical_utils/src/pond/automation/automation_registration.dart';

abstract class AutomationModule {
  Future<void> onBuild(AutomationContext context) async {}

  void onRegister(AutomationRegistration registration) {}
}
