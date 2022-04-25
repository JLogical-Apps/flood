import 'dart:io';

import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:jlogical_utils/src/pond/automation/automation_runner.dart';
import 'package:jlogical_utils/src/pond/automation_modules/build/build_automation_module.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

Future<void> automate({required List<String> args, required AutomationContext automationContext}) async {
  AutomationContext.global = automationContext;
  automationContext.registerModule(BuildAutomationModule());

  await runAutomation(args);
}

Directory automateOutputDirectory = Directory.current / 'tool' / 'output';
