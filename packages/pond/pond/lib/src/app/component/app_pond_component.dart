import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pond/src/app/component/app_pond_component_additional_setup.dart';
import 'package:pond/src/app/component/app_pond_page_context.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/page/app_page.dart';

abstract class AppPondComponent {
  void onRegister(AppPondContext context);

  Future onLoad(AppPondContext context);

  Widget wrapApp(AppPondContext context, Widget app);

  Widget wrapPage(
    AppPondContext context,
    Widget page,
    AppPondPageContext pageContext,
  );

  List<AppPage> get pages;
}

extension AppPondComponentExtension on AppPondComponent {
  void registerTo(AppPondContext context) {
    onRegister(context);
  }

  Future load(AppPondContext context) {
    return onLoad(context);
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
  void onRegister(AppPondContext context) {}

  @override
  Future onLoad(AppPondContext context) async {}

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
  List<AppPage> get pages => [];
}

abstract class AppPondComponentWrapper implements AppPondComponent {
  AppPondComponent get appPondComponent;
}

mixin IsAppPondComponentWrapper implements AppPondComponentWrapper {
  @override
  void onRegister(AppPondContext context) {
    appPondComponent.onRegister(context);
  }

  @override
  Future onLoad(AppPondContext context) {
    return appPondComponent.onLoad(context);
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
  List<AppPage> get pages => appPondComponent.pages;
}
