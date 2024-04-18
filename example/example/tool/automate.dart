import 'package:jlogical_utils/jlogical_utils_cli.dart';
import 'package:jlogical_utils/jlogical_utils_core.dart';

Future<void> main(List<String> args) async {
  await automate(
    args: args,
    automationContext: getAutomationContext(),
  );
}

AutomationContext getAutomationContext() {
  return DefaultAutomationContext()
    ..registerModule(EnvironmentAutomationModule())
    ..registerModule(FirebaseAutomationModule());
}
