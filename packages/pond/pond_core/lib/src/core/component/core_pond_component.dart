import 'dart:async';

import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/core/component/core_pond_component_additional_setup.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondComponent {
  void onRegister(CorePondContext context) {}

  Future onLoad(CorePondContext context) async {}
}

mixin IsCorePondComponent implements CorePondComponent {
  @override
  void onRegister(CorePondContext context) {}

  @override
  Future onLoad(CorePondContext context) async {}
}

abstract class CorePondComponentWrapper implements CorePondComponent {
  CorePondComponent get corePondComponent;
}

mixin IsCorePondComponentWrapper implements CorePondComponentWrapper {
  @override
  void onRegister(CorePondContext context) {
    corePondComponent.onRegister(context);
  }

  @override
  Future onLoad(CorePondContext context) {
    return corePondComponent.onLoad(context);
  }
}

mixin WithCorePondComponentDelegate implements IsCorePondComponentWrapper {}

abstract class MultiCorePondComponentWrapper implements CorePondComponent {
  List<CorePondComponent> get corePondComponents;
}

mixin IsMultiCorePondComponentWrapper implements MultiCorePondComponentWrapper {
  @override
  void onRegister(CorePondContext context) {
    for (final component in corePondComponents) {
      component.onRegister(context);
    }
  }

  @override
  Future onLoad(CorePondContext context) async {
    for (final component in corePondComponents) {
      await component.onLoad(context);
    }
  }
}

extension CorePondComponentExtension on CorePondComponent {
  void registerTo(CorePondContext context) {
    onRegister(context);
  }

  Future load(CorePondContext context) {
    return onLoad(context);
  }

  CorePondComponentAdditionalSetup withAdditionalSetup({
    void Function(CorePondContext context)? onBeforeRegister,
    void Function(CorePondContext context)? onAfterRegister,
    FutureOr Function(CorePondContext context)? onBeforeLoad,
    FutureOr Function(CorePondContext context)? onAfterLoad,
  }) {
    return CorePondComponentAdditionalSetup(
      corePondComponent: this,
      onBeforeRegister: onBeforeRegister,
      onAfterRegister: onAfterRegister,
      onBeforeLoad: onBeforeLoad,
      onAfterLoad: onAfterLoad,
    );
  }
}
