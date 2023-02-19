import 'package:flutter/material.dart';
import 'package:pond/src/app/context/app_pond_context_build_context_extensions.dart';
import 'package:pond/src/app/navigation/navigation_app_pond_component.dart';
import 'package:pond/src/app/page/app_page.dart';

extension NavigationBuildContextExtensions on BuildContext {
  NavigationAppPondComponent get _navigationComponent => appPondContext.find<NavigationAppPondComponent>();

  String get url {
    return _navigationComponent.getUrl(this);
  }

  Uri get uri {
    return _navigationComponent.getUri(this);
  }

  void warpTo(AppPage page) {
    _navigationComponent.warpTo(this, page);
  }

  void warpToLocation(String location) {
    _navigationComponent.warpToLocation(this, location);
  }

  Future<T?> push<T>(AppPage page) {
    return _navigationComponent.push<T>(this, page);
  }

  Future<T?> pushLocation<T>(String location) {
    return _navigationComponent.pushLocation(this, location);
  }

  Future<T> pushReplacement<T>(AppPage page) {
    return _navigationComponent.pushReplacement<T>(this, page);
  }
}
