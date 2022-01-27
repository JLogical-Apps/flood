import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/utils.dart';

Future<void> main(List<String> args) async {
  await automate(
    args: args,
    automationContext: AutomationContext()
      ..registerModule(AppIconAutomationModule(
        appIconForegroundFile: Directory.current / 'assets' - 'logo_foreground.png',
        backgroundColor: 0x172434,
      )),
  );
}
