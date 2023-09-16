import 'package:flutter/material.dart' hide Route;
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/context/app_pond_context_build_context_extensions.dart';
import 'package:pond/src/app/navigation/navigation_app_component.dart';

extension NavigationBuildContextExtensions on BuildContext {
  NavigationAppComponent get _navigationComponent => appPondContext.find<NavigationAppComponent>();

  String get location {
    return _navigationComponent.location;
  }

  Uri get uri {
    return _navigationComponent.uri;
  }

  Future<T?> push<T>(Route route) {
    return _navigationComponent.push<T>(route);
  }

  Future<T?> pushLocation<T>(String location) {
    return _navigationComponent.pushLocation(location);
  }

  Future<T?> pushUri<T>(Uri uri) {
    return _navigationComponent.pushUri(uri);
  }

  Future<void> pushReplacement(Route route) {
    return _navigationComponent.pushReplacement(route);
  }

  Future<void> pushReplacementUri(Uri uri) {
    return _navigationComponent.pushReplacementUri(uri);
  }

  Future<void> pushReplacementLocation(String location) {
    return _navigationComponent.pushReplacementLocation(location);
  }

  Future<void> warpTo(Route route) {
    return _navigationComponent.warpTo(route);
  }

  Future<void> warpToUri(Uri uri) {
    return _navigationComponent.warpToUri(uri);
  }

  Future<void> warpToLocation(String location) {
    return _navigationComponent.warpToLocation(location);
  }

  void pop<T>([T? result]) {
    return _navigationComponent.pop(result);
  }
}
