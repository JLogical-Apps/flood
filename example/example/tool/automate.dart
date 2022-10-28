import 'package:example/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<void> main(List<String> args) async {
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext)
    ..register(HelloWorldAutomatePondComponent());

  await Automate.automate(context: automatePondContext, args: args);
}

class HelloWorldAutomatePondComponent extends AutomatePondComponent {
  @override
  final List<AutomateCommand> commands = [
    AutomateCommand(name: 'hello_world', runner: () => print('hello!')),
  ];
}
