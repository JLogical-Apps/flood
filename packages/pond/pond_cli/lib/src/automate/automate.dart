import 'package:collection/collection.dart';
import 'package:pond_cli/src/automate/command/automate_command.dart';
import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';

class Automate {
  static Future<void> automate({
    required AutomatePondContext context,
    required List<String> args,
    Terminal? terminal,
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

    final instanceCommand = automateCommand.fromPath(args.skip(1).join(' '));

    final commandContext = AutomateCommandContext(automateContext: context, terminal: terminal);
    await instanceCommand.onRun(commandContext);
    await commandContext.cleanup();
  }

  static void _printUsage({required AutomatePondContext context}) async {
    print('===[Automate Usage]===');
    for (final command in context.commands) {
      print('${command.name}: ${command.description}');
    }
    print('');
  }
}
