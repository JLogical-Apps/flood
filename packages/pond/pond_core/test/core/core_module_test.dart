import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('can locate components in module.', () {
    final markerAComponent = MarkerAComponent();
    final markerBComponent = MarkerBComponent();
    final markerCComponent = MarkerCComponent();

    final corePondContext = CorePondContext();
    corePondContext.register(CorePondModule(
      corePondComponents: [
        markerAComponent,
        markerBComponent.withAdditionalSetup(),
        CorePondModule(corePondComponents: [
          markerCComponent,
        ])
      ],
    ));

    expect(corePondContext.locate<MarkerAComponent>(), markerAComponent);
    expect(corePondContext.locate<MarkerBComponent>(), markerBComponent);
    expect(corePondContext.locate<MarkerCComponent>(), markerCComponent);
  });

  test('components in a module register and load', () async {
    final markerAComponent = MarkerAComponent();
    var registered = false;
    var loaded = false;

    final corePondContext = CorePondContext()
      ..register(CorePondModule(
        corePondComponents: [
          markerAComponent.withAdditionalSetup(
            onAfterRegister: (_) => registered = true,
            onAfterLoad: (_) => loaded = true,
          ),
        ],
      ));

    await corePondContext.load();

    expect(registered, true);
    expect(loaded, true);
  });
}

class MarkerAComponent extends CorePondComponent {}

class MarkerBComponent extends CorePondComponent {}

class MarkerCComponent extends CorePondComponent {}
