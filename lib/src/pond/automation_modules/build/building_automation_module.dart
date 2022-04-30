import '../../automation/automation_context.dart';

abstract class BuildingAutomationModule {
  Future<void> onBuild(AutomationContext context);
}
