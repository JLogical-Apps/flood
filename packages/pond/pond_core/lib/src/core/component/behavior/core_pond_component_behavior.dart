import 'dart:async';

import 'package:pond_core/src/core/component/behavior/dependency_core_pond_component_behavior.dart';
import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondComponentBehavior {
  Future onRegister(CorePondContext context, CorePondComponent component) async {}

  Future onLoad(CorePondContext context, CorePondComponent component) async {}

  Future onReset(CorePondContext context, CorePondComponent component) async {}

  factory CorePondComponentBehavior({
    FutureOr Function(CorePondContext context, CorePondComponent component)? onRegister,
    FutureOr Function(CorePondContext context, CorePondComponent component)? onLoad,
    FutureOr Function(CorePondContext context, CorePondComponent component)? onReset,
  }) =>
      _CorePondComponentBehaviorImpl(
        registerHandler: onRegister,
        loadHandler: onLoad,
        resetHandler: onReset,
      );

  static CorePondComponentBehavior dependency<T extends CorePondComponent>() {
    return DependencyCorePondComponentBehavior<T>();
  }
}

class _CorePondComponentBehaviorImpl implements CorePondComponentBehavior {
  final FutureOr Function(CorePondContext context, CorePondComponent component)? registerHandler;
  final FutureOr Function(CorePondContext context, CorePondComponent component)? loadHandler;
  final FutureOr Function(CorePondContext context, CorePondComponent component)? resetHandler;

  _CorePondComponentBehaviorImpl({this.registerHandler, this.loadHandler, required this.resetHandler});

  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {
    await registerHandler?.call(context, component);
  }

  @override
  Future onLoad(CorePondContext context, CorePondComponent component) async {
    await loadHandler?.call(context, component);
  }

  @override
  Future onReset(CorePondContext context, CorePondComponent component) async {
    await resetHandler?.call(context, component);
  }
}

mixin IsCorePondComponentBehavior implements CorePondComponentBehavior {
  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {}

  @override
  Future onLoad(CorePondContext context, CorePondComponent component) async {}

  @override
  Future onReset(CorePondContext context, CorePondComponent component) async {}
}
