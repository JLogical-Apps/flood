import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/remote/export_core.dart';

const int _pondPort = 1236;
const int _debugViewPort = 1237;

Future<void> debug() async {
  final pondHost = await RemoteHost.initialize(port: _pondPort);
  final debugViewHost = await RemoteHost.initialize(
    port: _debugViewPort,
    commands: [
      SimpleCommand(
        name: 'list_commands',
        runner: (args) async {
          try {
            return await pondHost.run(commandName: 'list_commands');
          } catch (e) {
            print(e);
          }
        },
      ),
      SimpleCommand.wildcard(runner: (args) async {
        final name = args.remove('_name');
        try {
          return await pondHost.run(commandName: name, args: args);
        } catch (e) {
          print(e);
        }
      }),
    ],
  );
}
