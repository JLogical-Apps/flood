import 'dart:async';

import 'package:flutter/widgets.dart' hide Route;
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/page/app_page.dart';

class AppPondComponentAdditionalSetup with IsAppPondComponentWrapper {
  @override
  final AppPondComponent appPondComponent;

  final FutureOr Function(AppPondContext context)? onBeforeRegister;
  final FutureOr Function(AppPondContext context)? onAfterRegister;
  final FutureOr Function(AppPondContext context)? onBeforeLoad;
  final FutureOr Function(AppPondContext context)? onAfterLoad;
  final Widget Function(AppPondContext context, Widget app)? appWrapper;
  final Map<Route, AppPage> additionalPages;

  AppPondComponentAdditionalSetup({
    required this.appPondComponent,
    this.onBeforeRegister,
    this.onAfterRegister,
    this.onBeforeLoad,
    this.onAfterLoad,
    this.additionalPages = const {},
    this.appWrapper,
  });

  @override
  Future onRegister(AppPondContext context) async {
    await onBeforeRegister?.call(context);
    await appPondComponent.onRegister(context);
    await onAfterRegister?.call(context);
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

  @override
  Map<Route, AppPage> get pages => {...appPondComponent.pages, ...additionalPages};
}
