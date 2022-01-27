import 'dart:io';

import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:jlogical_utils/utils.dart';
import 'package:process_run/shell.dart';

mixin WithShellAutomationInteractor implements AutomationInteractor {
  Future<void> run(String command, {Directory? workingDirectory}) {
    return Shell(stdin: sharedStdIn, workingDirectory: workingDirectory?.relativePath).run(command);
  }
}
