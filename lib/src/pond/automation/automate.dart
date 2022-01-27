import 'dart:io';

import 'package:jlogical_utils/src/pond/automation/automation_context.dart';
import 'package:jlogical_utils/src/pond/automation/automation_runner.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

Future<void> automate({required List<String> args, required AutomationContext automationContext}) async {
  automationContext.register(
    name: 'build',
    description: 'Build the app.',
    args: (args) {
      args.addOption('environment', aliases: ['env'], defaultsTo: Environment.testing.name);
      args.addFlag('clean', defaultsTo: false);
    },
    action: _build,
  );

  await runAutomation(args, automationContext: automationContext);
}

Directory automateOutputDirectory = Directory.current / 'tool' / 'output';

Future<void> _build(AutomationContext context) async {
  if (context.isClean) {
    context.print('Building a clean version of the app!');
  } else {
    context.print('Building the app!');
  }
  await Future.wait(context.modules.map((module) => module.onBuild(context)));
}
