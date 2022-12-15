import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

const helloWorldCommandName = 'hello_world';

void main() {
  test('automate components registering and loading', () async {
    var coreRegistered = false;
    var coreLoaded = false;
    var automateRegistered = false;
    var automateLoaded = false;

    final corePondContext = CorePondContext();
    await corePondContext.register(TestCoreComponent().withAdditionalSetup(
      onBeforeRegister: (_) => coreRegistered = true,
      onBeforeLoad: (_) => coreLoaded = true,
    ));
    final automateContext = AutomatePondContext(corePondContext: corePondContext)
      ..register(TestAutomateComponent().withAdditionalSetup(
        onBeforeRegister: (_) => automateRegistered = true,
        onBeforeLoad: (_) => automateLoaded = true,
      ));

    expect(coreRegistered, true);
    expect(coreLoaded, false);
    expect(automateRegistered, true);
    expect(automateLoaded, false);

    await automateContext.load();

    expect(coreRegistered, true);
    expect(coreLoaded, true);
    expect(automateRegistered, true);
    expect(automateLoaded, true);
  });

  test('run is called on correct component', () async {
    var hasRun = false;
    final corePondContext = CorePondContext();
    await corePondContext.register(TestCoreComponent());
    final automateContext = AutomatePondContext(corePondContext: corePondContext)
      ..register(TestAutomateComponent(
        runner: () => hasRun = true,
      ));

    await Automate.automate(context: automateContext, args: [helloWorldCommandName]);

    expect(hasRun, true);
  });
}

class TestCoreComponent extends CorePondComponent {}

class TestAutomateComponent extends AutomatePondComponent {
  final void Function()? runner;

  TestAutomateComponent({this.runner});

  @override
  late final List<AutomateCommand> commands = [
    AutomateCommand(
      name: helloWorldCommandName,
      runner: () => runner?.call(),
    ),
  ];
}
