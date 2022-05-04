import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_module.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_stub.dart';
import 'package:jlogical_utils/src/pond/modules/core_module.dart';
import 'package:jlogical_utils/src/remote/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../automation/automation_context.dart';
import '../automation_modules/build/build_automation_module.dart';
import '../modules/logging/default_logging_module.dart';

const int _pondPort = 1236;
const int _debugViewPort = 1237;

const String _sourceField = '_source';
const String _sourceAutomation = 'automation';

Future<void> debug({AutomationContext? automationContext}) async {
  if (automationContext != null) {
    AutomationContext.global = automationContext;
    automationContext.registerModule(BuildAutomationModule());
  }

  AppContext.createGlobal()
    ..register(CoreModule())
    ..register(CommandModule());

  final pondHost = await RemoteHost.initialize(port: _pondPort);
  final debugViewHost = await RemoteHost.initialize(
    port: _debugViewPort,
    commands: [
      SimpleCommand(
        name: 'list_commands',
        runner: (args) async {
          try {
            final automationCommands = automationContext?.commands
                .map((command) => CommandStub.fromCommand(command)..extraValues[_sourceField] = _sourceAutomation)
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
        final source = args.remove(_sourceField);
        try {
          if (source == _sourceAutomation) {
            automationContext?.args = args;
            return await automationContext?.commandRunner.run(commandName: name, args: args);
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
