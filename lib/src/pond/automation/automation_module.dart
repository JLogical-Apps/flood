import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

abstract class AutomationModule {
  String get name;

  List<Command> get commands;

  AutomationContext get context => AutomationContext.global;

  Directory get cacheDirectory => automateOutputDirectory / name;
}
