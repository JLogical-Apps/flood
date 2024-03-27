import 'dart:async';

import 'package:flutter/material.dart' hide Route;
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_component_additional_setup.dart';
import 'package:pond/src/app/component/app_pond_page_context.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/page/app_page.dart';

abstract class AppPondComponent {
  Future onRegister(AppPondContext context);

  Future onLoad(AppPondContext context);

  Future onReset(AppPondContext context);

  Widget wrapApp(AppPondContext context, Widget app);

  Widget wrapPage(
    AppPondContext context,
    Widget page,
    AppPondPageContext pageContext,
  );

  Map<Route, AppPage> get pages;
}

extension AppPondComponentExtension on AppPondComponent {
  Future registerTo(AppPondContext context) async {
    await onRegister(context);
  }

  Future load(AppPondContext context) {
    return onLoad(context);
  }

  Future reset(AppPondContext context) {
    return onReset(context);
  }

  AppPondComponentAdditionalSetup withAdditionalSetup({
    void Function(AppPondContext context)? onBeforeRegister,
    void Function(AppPondContext context)? onAfterRegister,
    FutureOr Function(AppPondContext context)? onBeforeLoad,
    FutureOr Function(AppPondContext context)? onAfterLoad,
    Widget Function(AppPondContext context, Widget app)? appWrapper,
  }) {
    return AppPondComponentAdditionalSetup(
      appPondComponent: this,
      onBeforeRegister: onBeforeRegister,
      onAfterRegister: onAfterRegister,
      onBeforeLoad: onBeforeLoad,
      onAfterLoad: onAfterLoad,
      appWrapper: appWrapper,
    );
  }
}

mixin IsAppPondComponent implements AppPondComponent {
  @override
  Future onRegister(AppPondContext context) async {}

  @override
  Future onLoad(AppPondContext context) async {}

  @override
  Future onReset(AppPondContext context) async {}

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return app;
  }

  @override
  Widget wrapPage(
    AppPondContext context,
    Widget page,
    AppPondPageContext pageContext,
  ) {
    return page;
  }

  @override
  Map<Route, AppPage> get pages => {};
}

abstract class AppPondComponentWrapper implements AppPondComponent {
  AppPondComponent get appPondComponent;
}

mixin IsAppPondComponentWrapper implements AppPondComponentWrapper {
  @override
  Future onRegister(AppPondContext context) {
    return appPondComponent.onRegister(context);
  }

  @override
  Future onLoad(AppPondContext context) {
    return appPondComponent.onLoad(context);
  }

  @override
  Future onReset(AppPondContext context) {
    return appPondComponent.onReset(context);
  }

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return appPondComponent.wrapApp(context, app);
  }

  @override
  Widget wrapPage(
    AppPondContext context,
    Widget page,
    AppPondPageContext pageContext,
  ) {
    return appPondComponent.wrapPage(context, page, pageContext);
  }

  @override
  Map<Route, AppPage> get pages => appPondComponent.pages;
}
