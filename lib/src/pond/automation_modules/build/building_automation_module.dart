import 'package:jlogical_utils/automation.dart';

abstract class BuildingAutomationModule {
  Future<void> onBuild(AutomationContext context);
}
