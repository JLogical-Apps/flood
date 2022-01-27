import 'package:args/args.dart';
import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automation_context.dart';

abstract class AutomationModule {
  String get name;

  final List<Automation> automations = [];

  void registerAutomation({
    required String name,
    required Function(AutomationContext context) action,
    String? description,
    Function(ArgParser args)? args,
    String? category,
  }) {
    automations.add(Automation(
      name: name,
      description: description,
      action: action,
      args: args,
      category: category ?? this.name,
    ));
  }

  Future<void> onBuild(AutomationContext context) async {}
}
