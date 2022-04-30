import 'dart:io';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../patterns/export_core.dart';
import 'automate.dart';
import 'automation_context.dart';

abstract class AutomationModule {
  String get name;

  List<Command> get commands;

  AutomationContext get context => AutomationContext.global;

  Directory get cacheDirectory => automateOutputDirectory / name;
}
