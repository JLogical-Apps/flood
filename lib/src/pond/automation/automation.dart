import 'package:args/args.dart';
import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:jlogical_utils/src/pond/automation/automations_provider.dart';

class Automation implements AutomationsProvider {
  final String name;
  final String? description;
  final String? category;
  final Function(ArgParser args)? args;
  final Function(AutomationContext automationContext)? action;

  final List<Automation> automations = [];

  String? get categoryName => null;

  Automation({required this.name, this.description, this.category, this.args, required this.action});
}
