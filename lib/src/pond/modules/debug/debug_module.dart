import 'dart:async';

import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_stub.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';
import 'package:jlogical_utils/src/remote/export_core.dart';

import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../command/command_module.dart';

class DebugModule extends AppModule {
  static const int debugPort = 1236;

  final String address;
  final int port;

  DebugModule({String? address, this.port: debugPort}) : this.address = address ?? loopbackAddress;

  @override
  void onRegister(AppRegistration registration) {
    registration.register(CommandModule());
  }

  @override
  Future<void> onLoad(AppContext appContext) async {
    if (appContext.isRelease) {
      return;
    }

    final debugModules = AppContext.global.appModules.whereType<DebuggableModule>();

    await runZonedGuarded(() async {
      await RemoteHost.connect(
        address: loopbackAddress,
        port: debugPort,
        commands: [
          SimpleCommand(
            name: 'list_commands',
            runner: (args) {
              return debugModules
                  .expand((module) => module.debugCommands.map((command) =>
                      CommandStub.fromCommand(command, category: module.runtimeType.toString())
                        ..nameProperty.value = '${module.runtimeType}.${command.name}'))
                  .map((stub) => stub.state.values)
                  .toList();
            },
          ),
          ...debugModules.expand((module) => module.debugCommands
              .map((command) => SimpleCommand.fromCommand(command)..name = '${module.runtimeType}.${command.name}')),
        ],
      );
    }, (e, stack) {});
  }
}
