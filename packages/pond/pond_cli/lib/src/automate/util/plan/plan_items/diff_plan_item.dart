import 'dart:io';

import 'package:collection/collection.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/util/plan/plan_item.dart';

class DiffPlanItem with IsPlanItem {
  final File file;
  final String previousValue;

  DiffPlanItem({required this.previousValue, required this.file});

  @override
  Future<void> onPreview(AutomateCommandContext context) async {
    final newValue = await DataSource.static.file(file).get();
    if (previousValue == newValue) {
      return;
    }

    context.print('Diff of ${file.path}');

    final diffResult = calculateListDiff(
      previousValue.split('\n'),
      newValue.split('\n'),
      detectMoves: false,
    );
    final updates = diffResult.getUpdatesWithData().sorted((a, b) => getPosition(a).compareTo(getPosition(b)));
    for (final update in updates) {
      update.when(
        insert: (position, data) {
          context.print('+ [$position]: $data');
        },
        remove: (position, data) {
          context.print('- [$position]: $data');
        },
        change: (position, oldData, newData) {
          context.print('- [$position]: $oldData');
          context.print('+ [$position]: $newData');
        },
        move: (from, to, data) {
          throw UnimplementedError();
        },
      );
    }
  }

  @override
  Future<bool> onCanExecute(AutomateCommandContext context) async {
    return false;
  }

  @override
  Future<void> onExecute(AutomateCommandContext context) async {
    // Do nothing.
  }

  int getPosition(DataDiffUpdate update) {
    return update.when(
      insert: (position, _) => position,
      remove: (position, _) => position,
      change: (position, _, __) => position,
      move: (position, _, __) => position,
    );
  }
}
