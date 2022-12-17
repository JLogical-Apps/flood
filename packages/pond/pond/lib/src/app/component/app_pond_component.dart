import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/app/component/app_pond_component_additional_setup.dart';

abstract class AppPondComponent {
  void onRegister(AppPondContext context) {}

  Future onLoad(AppPondContext context) async {}

  /// Wrap [app] in other widgets.
  Widget wrapApp(AppPondContext context, Widget app) {
    return app;
  }
}

abstract class AppPondComponentWrapper implements AppPondComponent {
  AppPondComponent get appPondComponent;
}

mixin WithAppPondComponentDelegate implements AppPondComponentWrapper {
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
