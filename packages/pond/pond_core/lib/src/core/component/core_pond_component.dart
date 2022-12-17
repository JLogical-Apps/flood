import 'dart:async';

import 'package:pond_core/src/core/component/behavior/core_pond_component_behavior.dart';
import 'package:pond_core/src/core/component/core_pond_component_additional_setup.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondComponent {
  late CorePondContext context;

  List<CorePondComponentBehavior> get behaviors => [];
}

mixin IsCorePondComponent implements CorePondComponent {
  @override
  late CorePondContext context;
}

abstract class CorePondComponentWrapper implements CorePondComponent {
  CorePondComponent get corePondComponent;
}

mixin IsCorePondComponentWrapper implements CorePondComponentWrapper {
  @override
  List<CorePondComponentBehavior> get behaviors => corePondComponent.behaviors;

  @override
  late CorePondContext context;
}

extension CorePondComponentExtension on CorePondComponent {
  Future registerTo(CorePondContext context) async {
    this.context = context;
    for (final behavior in behaviors) {
      await behavior.onRegister(context, this);
    }
  }

  Future load(CorePondContext context) async {
    for (final behavior in behaviors) {
      await behavior.onLoad(context, this);
    }
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
