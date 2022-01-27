import 'package:args/args.dart';
import 'package:jlogical_utils/src/pond/automation/automation_context.dart';

class Automation {
  final String name;
  final String? description;
  final String? category;
  final Function(ArgParser args)? args;
  final Function(AutomationContext automationContext) action;

  const Automation({required this.name, this.description, this.category, this.args, required this.action});
}
