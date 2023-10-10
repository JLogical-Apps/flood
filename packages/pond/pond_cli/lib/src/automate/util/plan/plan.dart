import 'dart:io';

import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/util/plan/plan_item.dart';

class Plan {
  final List<PlanItem> items;

  Plan(this.items);

  Plan.run(String command, {required Directory workingDirectory})
      : items = [
          PlanItem.static.run(command, workingDirectory: workingDirectory),
        ];

  Future<void> preview(AutomateCommandContext context) async {
    for (final item in items) {
      await item.preview(context);
    }
  }

  Future<bool> canExecute(AutomateCommandContext context) async {
    for (final item in items) {
      if (await item.canExecute(context)) {
        return true;
      }
    }

    return false;
  }

  Future<void> execute(AutomateCommandContext context) async {
    for (final item in items) {
      await item.execute(context);
    }
  }
}
