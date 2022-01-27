import 'package:args/args.dart';
import 'package:jlogical_utils/src/pond/automation/automation_module.dart';

import 'automation.dart';
import 'automation_context.dart';

abstract class AutomationRegistration {
  List<Automation> get automations;

  List<AutomationModule> get modules;

  void registerModule(AutomationModule module);

  void register({
    required String name,
    String? description,
    Function(ArgParser parser)? args,
    required Function(AutomationContext context) action,
  });
}
