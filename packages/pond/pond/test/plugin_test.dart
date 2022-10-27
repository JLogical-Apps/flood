import 'package:flutter_test/flutter_test.dart';
import 'package:pond/pond.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('PondContext generates CorePondContext with correct components.', () {
    final markerCorePondComponent = TestCorePondComponent();

    final emptyPondContext = PondContext();
    final emptyCorePondContext = emptyPondContext.corePondContext;
    expect(emptyCorePondContext.locateOrNull<TestCorePondComponent>(), isNull);

    final pondContext = PondContext()
      ..register(PondPlugin(name: 'Test')..registerCoreComponent(markerCorePondComponent));
    final corePondContext = pondContext.corePondContext;
    expect(corePondContext.locate<TestCorePondComponent>(), markerCorePondComponent);
  });

  test('loading AppPondContext loads CorePondComponent', () async {
    final markerCorePondComponent = TestCorePondComponent();

    var isRegistered = false;
    var isLoaded = false;

    final pondContext = PondContext()
      ..register(PondPlugin(name: 'Test')
        ..registerCoreComponent(markerCorePondComponent.withAdditionalSetup(
          onAfterRegister: (_) => isRegistered = true,
          onAfterLoad: (_) => isLoaded = true,
        )));

    final appContext = pondContext.appPondContext;
    await appContext.load();

    expect(isRegistered, true);
    expect(isLoaded, true);
  });
}

class TestCorePondComponent extends CorePondComponent {}
