import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/app_pond_context.dart';

class AppPondComponentAdditionalSetup extends AppPondComponentWrapper {
  @override
  final AppPondComponent appPondComponent;

  final void Function(AppPondContext context)? onBeforeRegister;
  final void Function(AppPondContext context)? onAfterRegister;
  final FutureOr Function(AppPondContext context)? onBeforeLoad;
  final FutureOr Function(AppPondContext context)? onAfterLoad;
  final Widget Function(AppPondContext context, Widget app)? appWrapper;

  AppPondComponentAdditionalSetup({
    required this.appPondComponent,
    this.onBeforeRegister,
    this.onAfterRegister,
    this.onBeforeLoad,
    this.onAfterLoad,
    this.appWrapper,
  });

  @override
  void onRegister(AppPondContext context) {
    onBeforeRegister?.call(context);
    appPondComponent.onRegister(context);
    onAfterRegister?.call(context);
  }

  @override
  Future onLoad(AppPondContext context) async {
    await onBeforeLoad?.call(context);
    await appPondComponent.onLoad(context);
    await onAfterLoad?.call(context);
  }

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return appWrapper?.call(context, app) ?? app;
  }
}
