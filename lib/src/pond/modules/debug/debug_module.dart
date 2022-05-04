import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_stub.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';
import 'package:jlogical_utils/src/remote/export_core.dart';

import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../command/command_module.dart';

class DebugModule extends AppModule {
  static const String loopbackAddress = '10.0.2.2';
  static const int debugPort = 1236;

  final String address;
  final int port;

  DebugModule({this.address: loopbackAddress, this.port: debugPort});

  @override
  void onRegister(AppRegistration registration) {
    registration.register(CommandModule());
  }

  @override
  Future<void> onLoad(AppContext appContext) async {
    if (kReleaseMode) {
      return;
    }

    final debugCommands = AppContext.global.appModules
        .whereType<DebuggableModule>()
        .expand((debuggableModule) => debuggableModule.debugCommands);

    try {
      await RemoteHost.connect(
        address: loopbackAddress,
        port: debugPort,
        commands: [
          SimpleCommand(
            name: 'list_commands',
            runner: (args) {
              return debugCommands
                  .map((command) => CommandStub.fromCommand(command))
                  .map((stub) => stub.state.values)
                  .toList();
            },
          ),
          ...debugCommands,
        ],
      );
    } catch (e) {}
  }
}
