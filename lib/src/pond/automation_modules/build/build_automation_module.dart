import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';

class BuildAutomationModule extends AutomationModule {
  @override
  String get name => 'Build';

  BuildAutomationModule() {
    registerAutomation(
      name: 'build',
      description: 'Builds the app.',
      action: _build,
      category: null,
      args: (args) {
        args.addOption('environment', aliases: ['env'], defaultsTo: Environment.testing.name);
        args.addFlag('clean', defaultsTo: false);
      },
    );
  }
}

Future<void> _build(AutomationContext context) async {
  if (context.isClean) {
    context.print('Building a clean version of the app!');
  } else {
    context.print('Building the app!');
  }
  await Future.wait(context.modules.map((module) => module.onBuild(context)));
}
