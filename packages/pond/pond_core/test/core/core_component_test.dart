import 'dart:async';

import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('registering a component allows you to locate it.', () async {
    final testPondComponent = TestPondComponent();
    final corePondContext = CorePondContext();
    await corePondContext.register(testPondComponent);
    expect(corePondContext.locate<TestPondComponent>(), testPondComponent);
  });

  test('onRegister and onLoad for CorePondComponent.', () async {
    var isRegistered = false;
    var isLoaded = false;
    final testPondComponent = TestPondComponent(
      onRegistered: (_) => isRegistered = true,
      onLoaded: (_) => isLoaded = true,
    );

    final corePondContext = CorePondContext();
    await corePondContext.register(testPondComponent);
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

    final corePondContext = CorePondContext();
    await corePondContext.register(testPondComponent.withAdditionalSetup(
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
    final corePondContext = CorePondContext();
    await corePondContext.register(corePondComponent.withAdditionalSetup());

    expect(corePondContext.locate<TestPondComponent>(), corePondComponent);
  });

  test('CorePondComponent with dependency on another CorePondComponent.', () {
    expect(
      () async {
        final corePondContext = CorePondContext();
        await corePondContext.register(DependentPondComponent());
      },
      throwsA(isA<Exception>()),
    );
    expect(
        () => CorePondContext()
          ..register(TestPondComponent())
          ..register(DependentPondComponent()),
        returnsNormally);
  });
}

class TestPondComponent extends CorePondComponent {
  final void Function(CorePondContext context)? onRegistered;
  final FutureOr Function(CorePondContext context)? onLoaded;

  TestPondComponent({this.onRegistered, this.onLoaded});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) => onRegistered?.call(context),
          onLoad: (context, component) => onLoaded?.call(context),
        )
      ];
}

class DependentPondComponent extends CorePondComponent {
  @override
  List<CorePondComponentBehavior> get behaviors => [CorePondComponentBehavior.dependency<TestPondComponent>()];
}
