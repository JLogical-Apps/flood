import 'dart:io';

import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/util/plan/plan_item.dart';

class RunPlanItem with IsPlanItem {
  final String command;
  final Directory workingDirectory;

  RunPlanItem({required this.command, required this.workingDirectory});

  @override
  Future<void> onPreview(AutomateCommandContext context) async {
    context.print('Run `$command`');
  }

  @override
  Future<bool> onCanExecute(AutomateCommandContext context) async {
    return true;
  }

  @override
  Future<void> onExecute(AutomateCommandContext context) async {
    context.run(command, workingDirectory: workingDirectory);
  }
}
