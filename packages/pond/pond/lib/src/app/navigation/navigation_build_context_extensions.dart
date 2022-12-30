import 'package:flutter/material.dart';
import 'package:pond/src/app/context/app_pond_context_build_context_extensions.dart';
import 'package:pond/src/app/navigation/navigation_app_pond_component.dart';
import 'package:pond/src/app/page/app_page.dart';

extension NavigationBuildContextExtensions on BuildContext {
  NavigationAppPondComponent get _navigationComponent => appPondContext.find<NavigationAppPondComponent>();

  void warpTo(AppPage page) {
    _navigationComponent.warpTo(this, page);
  }

  Future<T> push<T>(AppPage page) {
    return _navigationComponent.push<T>(this, page);
  }

  Future<T> pushReplacement<T>(AppPage page) {
    return _navigationComponent.pushReplacement<T>(this, page);
  }
}
