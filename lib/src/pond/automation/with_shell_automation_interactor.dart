import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:process_run/shell.dart';

mixin WithShellAutomationInteractor implements AutomationInteractor {
  void run(String command) {
    Shell().run(command);
  }
}
