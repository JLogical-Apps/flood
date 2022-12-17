import 'dart:io';

import 'package:example/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<void> main(List<String> args) async {
  final automatePondContext =
      AutomatePondContext(corePondContext: await getCorePondContext(environmentConfig: AutomateEnvironmentConfig()))
        ..register(HelloWorldAutomatePondComponent());

  await Automate.automate(context: automatePondContext, args: args);
}

class AutomateEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  EnvironmentConfig get environmentConfig =>
      EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.overrides.yaml').environmental(
            (type) => EnvironmentConfig.static.collapsed([
              EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.overrides.yaml'),
              if (type == EnvironmentType.static.testing)
                EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.testing.yaml'),
              if (type == EnvironmentType.static.device)
                EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.device.yaml'),
              if (type == EnvironmentType.static.qa)
                EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.uat.yaml'),
              if (type == EnvironmentType.static.production)
                EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.production.yaml'),
              EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.yaml'),
            ]),
          );
}

class HelloWorldAutomatePondComponent extends AutomatePondComponent {
  @override
  final List<AutomateCommand> commands = [
    AutomateCommand(name: 'hello_world', runner: () => print('hello!')),
  ];
}
