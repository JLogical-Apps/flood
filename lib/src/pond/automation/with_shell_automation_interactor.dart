import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:process_run/shell.dart';

mixin WithShellAutomationInteractor implements AutomationInteractor {
  Future<void> run(String command) {
    return Shell(stdin: sharedStdIn).run(command);
  }
}
