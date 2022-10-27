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

  test('registering and loading CorePondComponent with additional setup.', () async {
    var isBeforeRegistered = false;
    var isRegistered = false;
    var isAfterRegistered = false;
    var isBeforeLoaded = false;
    var isLoaded = false;
    var isAfterLoaded = false;

    final testPondComponent = TestPondComponent(
      onRegistered: (_) => isRegistered = true,
      onLoaded: (_) => isLoaded = true,
    );

    final corePondContext = CorePondContext()
      ..register(testPondComponent.withAdditionalSetup(
        onBeforeRegister: (_) => isBeforeRegistered = true,
        onAfterRegister: (_) => isAfterRegistered = true,
        onBeforeLoad: (_) => isBeforeLoaded = true,
        onAfterLoad: (_) => isAfterLoaded = true,
      ));

    expect(isBeforeRegistered, true);
    expect(isRegistered, true);
    expect(isAfterRegistered, true);
    expect(isBeforeLoaded, false);
    expect(isLoaded, false);
    expect(isAfterLoaded, false);

    await corePondContext.load();

    expect(isBeforeRegistered, true);
    expect(isRegistered, true);
    expect(isAfterRegistered, true);
    expect(isBeforeLoaded, true);
    expect(isLoaded, true);
    expect(isAfterLoaded, true);
  });

  test('locating CorePondComponent with additional setup.', () async {
    final corePondComponent = TestPondComponent();
    final corePondContext = CorePondContext()..register(corePondComponent.withAdditionalSetup());

    expect(corePondContext.locate<TestPondComponent>(), corePondComponent);
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
