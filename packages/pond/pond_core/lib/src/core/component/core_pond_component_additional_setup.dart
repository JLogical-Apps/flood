import 'dart:async';

import 'package:pond_core/src/core/component/behavior/core_pond_component_behavior.dart';
import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

class CorePondComponentAdditionalSetup with IsCorePondComponentWrapper {
  @override
  final CorePondComponent corePondComponent;

  final void Function(CorePondContext context)? onBeforeRegister;
  final void Function(CorePondContext context)? onAfterRegister;
  final FutureOr Function(CorePondContext context)? onBeforeLoad;
  final FutureOr Function(CorePondContext context)? onAfterLoad;

  CorePondComponentAdditionalSetup({
    required this.corePondComponent,
    this.onBeforeRegister,
    this.onAfterRegister,
    this.onBeforeLoad,
    this.onAfterLoad,
  });

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) => onBeforeRegister?.call(context),
          onLoad: (context, component) => onBeforeLoad?.call(context),
        ),
        ...corePondComponent.behaviors,
        CorePondComponentBehavior(
          onRegister: (context, component) => onAfterRegister?.call(context),
          onLoad: (context, component) => onAfterLoad?.call(context),
        ),
      ];
}
