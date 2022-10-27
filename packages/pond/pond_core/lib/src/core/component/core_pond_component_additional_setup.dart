import 'dart:async';

import 'package:pond_core/pond_core.dart';

class CorePondComponentAdditionalSetup extends CorePondComponentWrapper {
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
  void onRegister(CorePondContext context) {
    onBeforeRegister?.call(context);
    corePondComponent.onRegister(context);
    onAfterRegister?.call(context);
  }

  @override
  Future onLoad(CorePondContext context) async {
    await onBeforeLoad?.call(context);
    await corePondComponent.onLoad(context);
    await onAfterLoad?.call(context);
  }
}
