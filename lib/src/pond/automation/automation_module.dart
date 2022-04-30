import 'dart:io';

import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automations_provider.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

abstract class AutomationModule {
  String get name;

  List<Command> get commands;

  AutomationContext get context => AutomationContext.global;

  Directory get cacheDirectory => automateOutputDirectory / name;
}
