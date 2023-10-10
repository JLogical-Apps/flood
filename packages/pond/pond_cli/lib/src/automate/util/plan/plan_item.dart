import 'dart:async';
import 'dart:io';

import 'package:pond_cli/pond_cli.dart';
import 'package:pond_cli/src/automate/util/plan/plan_items/diff_plan_item.dart';
import 'package:pond_cli/src/automate/util/plan/plan_items/run_plan_item.dart';

abstract class PlanItem {
  Future<void> onPreview(AutomateCommandContext context);

  Future<bool> onCanExecute(AutomateCommandContext context);

  Future<void> onExecute(AutomateCommandContext context);

  factory PlanItem({
    required FutureOr Function(AutomateCommandContext context) onPreview,
    required FutureOr<bool> Function(AutomateCommandContext context) onCanExecute,
    required FutureOr Function(AutomateCommandContext context) onExecute,
  }) =>
      _PlanItemImpl(
        onPreview: onPreview,
        onCanExecute: onCanExecute,
        onExecute: onExecute,
      );

  static final PlanItemStatic static = PlanItemStatic();
}

class PlanItemStatic {
  PlanItem diff({required String previousValue, required File file}) =>
      DiffPlanItem(previousValue: previousValue, file: file);

  PlanItem run(String command, {required Directory workingDirectory}) =>
      RunPlanItem(command: command, workingDirectory: workingDirectory);

  PlanItem execute(
    String name,
    FutureOr Function(AutomateCommandContext context) onExecute, {
    FutureOr<bool> Function(AutomateCommandContext context)? onCanExecute,
  }) =>
      PlanItem(
        onPreview: (context) => context.print(name),
        onExecute: onExecute,
        onCanExecute: onCanExecute ?? (_) async => true,
      );
}

extension PlanItemExtensions on PlanItem {
  Future<void> preview(AutomateCommandContext context) => onPreview(context);

  Future<bool> canExecute(AutomateCommandContext context) => onCanExecute(context);

  Future<void> execute(AutomateCommandContext context) => onExecute(context);
}

mixin IsPlanItem implements PlanItem {}

class _PlanItemImpl with IsPlanItem {
  final FutureOr Function(AutomateCommandContext context) _onPreview;
  final FutureOr<bool> Function(AutomateCommandContext context) _onCanExecute;
  final FutureOr Function(AutomateCommandContext context) _onExecute;

  _PlanItemImpl({
    required FutureOr Function(AutomateCommandContext context) onPreview,
    required FutureOr<bool> Function(AutomateCommandContext context) onCanExecute,
    required FutureOr Function(AutomateCommandContext context) onExecute,
  })  : _onPreview = onPreview,
        _onCanExecute = onCanExecute,
        _onExecute = onExecute;

  @override
  Future<void> onPreview(AutomateCommandContext context) async {
    await _onPreview(context);
  }

  @override
  Future<bool> onCanExecute(AutomateCommandContext context) async {
    return await _onCanExecute(context);
  }

  @override
  Future<void> onExecute(AutomateCommandContext context) async {
    await _onExecute(context);
  }
}
