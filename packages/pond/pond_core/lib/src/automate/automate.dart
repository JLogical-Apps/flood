import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/automate/command/automate_command_context.dart';

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
  }
}
