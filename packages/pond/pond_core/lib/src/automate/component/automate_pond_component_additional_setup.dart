import 'dart:async';

import 'package:pond_core/src/automate/component/automate_pond_component.dart';
import 'package:pond_core/src/automate/context/automate_pond_context.dart';

class AutomatePondComponentAdditionalSetup extends AutomatePondComponentWrapper {
  @override
  final AutomatePondComponent automatePondComponent;

  final void Function(AutomatePondContext context)? onBeforeRegister;
  final void Function(AutomatePondContext context)? onAfterRegister;
  final FutureOr Function(AutomatePondContext context)? onBeforeLoad;
  final FutureOr Function(AutomatePondContext context)? onAfterLoad;

  AutomatePondComponentAdditionalSetup({
    required this.automatePondComponent,
    this.onBeforeRegister,
    this.onAfterRegister,
    this.onBeforeLoad,
    this.onAfterLoad,
  });

  @override
  void onRegister(AutomatePondContext context) {
    onBeforeRegister?.call(context);
    automatePondComponent.onRegister(context);
    onAfterRegister?.call(context);
  }

  @override
  Future onLoad(AutomatePondContext context) async {
    await onBeforeLoad?.call(context);
    await automatePondComponent.onLoad(context);
    await onAfterLoad?.call(context);
  }
}
