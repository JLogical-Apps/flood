import 'package:flutter/material.dart' hide Route;
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/pond_app.dart';

extension NavigationBuildContextExtensions on BuildContext {
  Uri get uri => PondApp.currentUri;

  String get location => uri.toString();

  Future<void> pushUri(Uri uri) {
    return PondApp.router.pushUri(uri);
  }

  Future<void> push(Route route) {
    return pushUri(route.uri);
  }

  Future<void> pushLocation(String location) {
    return pushUri(Uri.parse(location));
  }

  Future<void> pushReplacementUri(Uri uri) {
    return PondApp.router.pushReplacementUri(uri);
  }

  Future<void> pushReplacement(Route route) {
    return pushReplacementUri(route.uri);
  }

  Future<void> pushReplacementLocation(String location) {
    return pushReplacementUri(Uri.parse(location));
  }

  Future<void> warpToUri(Uri uri) {
    return PondApp.router.warpToUri(uri);
  }

  Future<void> warpTo(Route route) {
    return warpToUri(route.uri);
  }

  Future<void> warpToLocation(String location) {
    return warpToUri(Uri.parse(location));
  }

  void pop() {
    return PondApp.router.pop();
  }
}
