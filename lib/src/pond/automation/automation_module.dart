import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automations_provider.dart';

abstract class AutomationModule implements AutomationsProvider {
  String get name;

  final List<Automation> automations = [];

  String get categoryName => name;
}
