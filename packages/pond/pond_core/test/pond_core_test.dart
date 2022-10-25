import 'dart:async';

import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('registering a component allows you to locate it.', () {
    final testPondComponent = TestPondComponent();
    final corePondContext = CorePondContext()..register(testPondComponent);
    expect(corePondContext.locate<TestPondComponent>(), testPondComponent);
  });

  test('onRegister and onLoad for CorePondComponent.', () async {
    var isRegistered = false;
    var isLoaded = false;
    final testPondComponent = TestPondComponent(
      onRegistered: (_) => isRegistered = true,
      onLoaded: (_) => isLoaded = true,
    );

    final corePondContext = CorePondContext()..register(testPondComponent);
    expect(isRegistered, true);
    expect(isLoaded, false);

    await corePondContext.load();
    expect(isRegistered, true);
    expect(isLoaded, true);
  });
}

class TestPondComponent extends CorePondComponent {
  final void Function(CorePondContext context)? onRegistered;
  final FutureOr Function(CorePondContext context)? onLoaded;

  TestPondComponent({this.onRegistered, this.onLoaded});

  @override
  void onRegister(CorePondContext context) {
    onRegistered?.call(context);
  }

  @override
  Future onLoad(CorePondContext context) async {
    onLoaded?.call(context);
  }
}
