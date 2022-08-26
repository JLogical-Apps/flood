import 'package:flutter_test/flutter_test.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/pond/context/pond_plugin.dart';

void main() {
  test('PondContext generates CorePondContext with correct components.', () async {
    final markerCorePondComponent = CorePondComponent();

    final emptyPondContext = PondContext();
    final emptyCorePondContext = emptyPondContext.corePondContext;
    expect(emptyCorePondContext.components, isNot(contains(markerCorePondComponent)));

    final pondContext = PondContext()..register(PondPlugin()..registerCoreComponent(markerCorePondComponent));
    final corePondContext = pondContext.corePondContext;
    expect(corePondContext.components, contains(markerCorePondComponent));
  });
}
