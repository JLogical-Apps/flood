import 'dart:io';

import 'package:jlogical_utils/src/pond/automation/automation.dart';
import 'package:jlogical_utils/src/pond/automation/automations_provider.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

import 'automate.dart';

abstract class AutomationModule implements AutomationsProvider {
  String get name;

  final List<Automation> automations = [];

  String get categoryName => name;

  Directory get cacheDirectory => automateOutputDirectory / name;
}
