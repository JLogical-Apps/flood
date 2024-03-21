import 'package:pond_cli/pond_cli.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

const helloWorldCommandName = 'hello_world';

const echoCommandName = 'echo';

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
    final automateContext = AutomatePondContext(corePondContext: CorePondContext())
      ..register(TestAutomateComponent(
        runner: () => hasRun = true,
      ));

    await Automate.testAutomate(context: automateContext, args: [helloWorldCommandName]);

    expect(hasRun, true);
  });

  test('automate command properties.', () async {
    final automateContext = AutomatePondContext(corePondContext: CorePondContext())..register(EchoAutomateComponent());

    var captureTerminal = Terminal.static.capture;
    await Automate.testAutomate(
      context: automateContext,
      args: [echoCommandName, '"Hello World!"'],
      terminalGetter: (_) => captureTerminal,
    );

    captureTerminal = Terminal.static.capture;
    await Automate.testAutomate(
      context: automateContext,
      args: [echoCommandName, '"Hello World!"', 'repeat:3'],
      terminalGetter: (_) => captureTerminal,
    );

    expect(captureTerminal.output, ['print: Hello World!'].repeat(3));
  });
}

class TestCoreComponent extends CorePondComponent {}

class TestAutomateComponent with IsAutomatePondComponent {
  final void Function()? runner;

  TestAutomateComponent({this.runner});

  @override
  late final List<AutomateCommand> commands = [
    AutomateCommand.simple(
      name: helloWorldCommandName,
      description: 'Prints Hello World',
      runner: (context) => runner?.call(),
      pathDefinition: AutomatePathDefinition.empty,
    ),
  ];
}

class EchoAutomateComponent with IsAutomatePondComponent {
  @override
  late final List<AutomateCommand> commands = [
    EchoAutomateCommand(),
  ];
}

class EchoAutomateCommand extends AutomateCommand<EchoAutomateCommand> {
  @override
  String get name => 'echo';

  @override
  String get description => 'Echoes the input.';

  late final echoField = field<String>(name: 'echo').required();

  late final repeatField = field<int>(name: 'repeat').withFallback(() => 1);

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(echoField);

  @override
  List<AutomateCommandProperty> get parameters => [repeatField];

  @override
  EchoAutomateCommand copy() {
    return EchoAutomateCommand();
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    for (var i = 0; i < repeatField.value; i++) {
      context.coreProject.print(echoField.value);
    }
  }
}
