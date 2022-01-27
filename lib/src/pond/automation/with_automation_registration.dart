import 'package:args/args.dart';
import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:jlogical_utils/src/pond/automation/automation_module.dart';
import 'package:jlogical_utils/src/pond/automation/automation_registration.dart';

mixin WithAutomationRegistration implements AutomationRegistration {
  final List<Automation> automations = [];
  final List<AutomationModule> modules = [];

  void registerModule(AutomationModule module) {
    modules.add(module);
    module.onRegister(this);
  }

  void register({
    required String name,
    String? description,
    Function(ArgParser parser)? args,
    required Function(AutomationContext context) action,
  }) {
    automations.add(Automation(name: name, description: description, args: args, action: action));
  }
}
