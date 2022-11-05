import 'dart:async';

import 'package:pond_core/src/core/component/behavior/dependency_core_pond_component_behavior.dart';
import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondComponentBehavior {
  void onRegister(CorePondContext context, CorePondComponent component) {}

  Future onLoad(CorePondContext context, CorePondComponent component) async {}

  factory CorePondComponentBehavior({
    void Function(CorePondContext context, CorePondComponent component)? onRegister,
    FutureOr Function(CorePondContext context, CorePondComponent component)? onLoad,
  }) =>
      _CorePondComponentBehaviorImpl(
        registerHandler: onRegister,
        loadHandler: onLoad,
      );

  static CorePondComponentBehavior dependency<T extends CorePondComponent>() {
    return DependencyCorePondComponentBehavior<T>();
  }
}

class _CorePondComponentBehaviorImpl implements CorePondComponentBehavior {
  final void Function(CorePondContext context, CorePondComponent component)? registerHandler;
  final FutureOr Function(CorePondContext context, CorePondComponent component)? loadHandler;

  _CorePondComponentBehaviorImpl({this.registerHandler, this.loadHandler});

  @override
  void onRegister(CorePondContext context, CorePondComponent component) {
    registerHandler?.call(context, component);
  }

  @override
  Future onLoad(CorePondContext context, CorePondComponent component) async {
    await loadHandler?.call(context, component);
  }
}

mixin IsCorePondComponentBehavior implements CorePondComponentBehavior {
  @override
  void onRegister(CorePondContext context, CorePondComponent component) {}

  @override
  Future onLoad(CorePondContext context, CorePondComponent component) async {}
}
