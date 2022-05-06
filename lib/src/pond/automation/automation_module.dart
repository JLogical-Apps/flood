import 'dart:io';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../patterns/export_core.dart';
import 'automate.dart';
import 'automation_context.dart';

abstract class AutomationModule {
  String get name;

  /// Whether to modify the names of its sub-commands to include this module's name.
  /// For example, if [name] is "firebase" and [modifyCommandNames] is true, then all sub-commands
  /// must have `firebase command` when being used.
  /// Otherwise, the module's name must be omitted.
  ///
  /// Set this to false for global commands that will never have clashing names with other commands.
  bool get modifyCommandNames => true;

  List<Command> get commands;

  AutomationContext get context => AutomationContext.global;

  Directory get cacheDirectory => automateOutputDirectory / name;
}
