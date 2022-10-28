import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';

void main() {
  test('automate components registering and loading', () async {
    var coreRegistered = false;
    var coreLoaded = false;
    var automateRegistered = false;
    var automateLoaded = false;

    final corePondContext = CorePondContext()
      ..register(TestCoreComponent().withAdditionalSetup(
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
}

class TestCoreComponent extends CorePondComponent {}

class TestAutomateComponent extends AutomatePondComponent {}
