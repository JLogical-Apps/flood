import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:args/args.dart';

abstract class AutomationsProvider {
  List<Automation> get automations;

  String? get categoryName;
}

extension AutomationsProviderExtensions on AutomationsProvider {
  Automation registerAutomation({
    required String name,
    Function(AutomationContext context)? action,
    String? description,
    Function(ArgParser args)? args,
    String? category,
  }) {
    final automation = Automation(
      name: name,
      description: description,
      action: action,
      args: args,
      category: categoryName,
    );
    automations.add(automation);
    return automation;
  }
}
