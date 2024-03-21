import 'dart:io';

import 'package:collection/collection.dart';
import 'package:pond_cli/src/automate/command/automate_command.dart';
import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/command/path/automate_path.dart';
import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';

class Automate {
  static Future<void> automate({
    required AutomatePondContext context,
    required List<String> args,
    Directory Function(Directory coreDirectory)? appDirectoryGetter,
    Terminal Function(Directory coreDirectory)? terminalGetter,
  }) async {
    if (args.isEmpty) {
      _printUsage(context: context);
      return;
    }

    await context.load();

    final commandName = args[0];
    final automateCommand = context.commands.firstWhereOrNull((command) => command.name == commandName);
    if (automateCommand == null) {
      _printUsage(context: context);
      return;
    }

    automateCommand as AutomateCommand<AutomateCommand>;

    final automatePath = AutomatePath.parse(args.skip(1).join(' '));
    final instanceCommand = automateCommand.fromPath(automatePath);

    final commandContext = AutomateCommandContext(
      automateContext: context,
      path: automatePath,
      terminalGetter: terminalGetter,
      appDirectoryGetter: appDirectoryGetter,
    );
    await instanceCommand.onRun(commandContext);
    await commandContext.cleanup();
  }

  static Future<void> testAutomate({
    required AutomatePondContext context,
    required List<String> args,
    Terminal Function(Directory coreDirectory)? terminalGetter,
  }) =>
      automate(
        context: context,
        args: args,
        appDirectoryGetter: (core) => core, // Just use the core directory as the app directory when testing.
        terminalGetter: terminalGetter,
      );

  static void _printUsage({required AutomatePondContext context}) async {
    print('===[Automate Usage]===');
    for (final command in context.commands) {
      print('${command.name}: ${command.description}');
    }
    print('');
  }
}
