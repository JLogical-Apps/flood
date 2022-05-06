import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_module.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_stub.dart';
import 'package:jlogical_utils/src/remote/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../automation/automation_context.dart';
import '../automation_modules/build/build_automation_module.dart';
import '../modules/logging/default_logging_module.dart';

const int _pondPort = 1236;
const int _debugViewPort = 1237;

const String _fieldSource = '_source';
const String _sourceAutomation = 'automation';

const String _fieldModule = '_module';

Future<void> debug({AutomationContext? automationContext}) async {
  if (automationContext != null) {
    AutomationContext.global = automationContext;
    automationContext.registerModule(BuildAutomationModule());
  }

  final context = await AppContext.create();
  context..register(CommandModule());

  final pondHost = await RemoteHost.initialize(port: _pondPort);

  await RemoteHost.initialize(
    port: _debugViewPort,
    commands: [
      SimpleCommand(
        name: 'list_commands',
        runner: (args) async {
          try {
            final automationCommands = automationContext?.modules
                .expand(
                    (module) => module.commands.map((command) => CommandStub.fromCommand(command, category: module.name)
                      ..extraValues[_fieldSource] = _sourceAutomation
                      ..extraValues[_fieldModule] = module.name))
                .map((stub) => stub.state.values)
                .toList();

            final remoteCommands =
                await guardAsync(() => pondHost.run(commandName: 'list_commands').timeout(Duration(seconds: 1)));

            return [...?remoteCommands, ...?automationCommands];
          } catch (e, stack) {
            logError(e);
            logError(stack);
          }
        },
      ),
      SimpleCommand.wildcard(runner: (args) async {
        final name = args.remove('_name');
        final moduleName = args.remove(_fieldModule);
        final source = args.remove(_fieldSource);
        try {
          if (source == _sourceAutomation) {
            automationContext!.args = args;
            final command = _getAutomationCommand(
              context: automationContext,
              commandName: name,
              moduleName: moduleName,
            );
            return command.run(args);
          } else {
            return await pondHost.run(commandName: name, args: args);
          }
        } catch (e) {
          print(e);
        }
      }),
    ],
  );
}

Command _getAutomationCommand({
  required AutomationContext context,
  required String? moduleName,
  required String commandName,
}) {
  if (moduleName == null) {
    return context.unparentedCommands.firstWhere((command) => command.name == commandName);
  }

  final module = context.modules.firstWhere((module) => module.name == moduleName);
  return module.commands.firstWhere((command) => command.name == commandName);
}
