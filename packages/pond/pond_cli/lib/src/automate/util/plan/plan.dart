import 'dart:async';
import 'dart:io';

import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/util/plan/plan_item.dart';

class Plan {
  final String? name;
  final List<PlanItem> items;

  Plan(this.items, {this.name});

  Plan.run(String command, {this.name, required Directory workingDirectory})
      : items = [
          PlanItem.static.run(command, workingDirectory: workingDirectory),
        ];

  Plan.execute(
    String actionName,
    FutureOr Function(AutomateCommandContext context) onExecute, {
    FutureOr<bool> Function(AutomateCommandContext context)? onCanExecute,
    this.name,
  }) : items = [
          PlanItem.static.execute(
            actionName,
            onExecute,
            onCanExecute: onCanExecute,
          ),
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
