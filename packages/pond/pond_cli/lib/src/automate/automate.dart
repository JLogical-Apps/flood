import 'package:collection/collection.dart';
import 'package:pond_cli/pond_cli.dart';

class Automate {
  static Future<void> automate({required AutomatePondContext context, required List<String> args}) async {
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

    final commandContext = AutomateCommandContext(automateContext: context);
    await automateCommand.run(commandContext);
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
