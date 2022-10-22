import 'package:flutter_test/flutter_test.dart';
import 'package:pond/pond.dart';

void main() {
  test('PondContext generates CorePondContext with correct components.', () async {
    final markerCorePondComponent = TestCorePondComponent();

    final emptyPondContext = PondContext();
    final emptyCorePondContext = emptyPondContext.corePondContext;
    expect(emptyCorePondContext.components, isNot(contains(markerCorePondComponent)));

    final pondContext = PondContext()
      ..register(PondPlugin(name: 'Test')..registerCoreComponent(markerCorePondComponent));
    final corePondContext = pondContext.corePondContext;
    expect(corePondContext.components, contains(markerCorePondComponent));
  });
}

class TestCorePondComponent extends CorePondComponent {}
