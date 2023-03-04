import 'package:collection/collection.dart';
import 'package:pond_cli/pond_cli.dart';

class Automate {
  static Future<void> automate({required AutomatePondContext context, required List<String> args}) async {
    if (args.isEmpty) {
      return;
    }

    await context.load();

    final commandName = args[0];
    final automateCommand = context.commands.firstWhereOrNull((command) => command.name == commandName);

    final commandContext = AutomateCommandContext(automateContext: context);
    await automateCommand?.run(commandContext);
    await commandContext.cleanup();
  }
}
