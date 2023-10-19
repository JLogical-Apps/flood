import 'package:flutter/material.dart' hide Route;
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/pond_app.dart';

extension NavigationBuildContextExtensions on BuildContext {
  Uri get uri => PondApp.currentUri;

  String get location => uri.toString();

  Future<void> pushUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) {
    return PondApp.router.pushUri(uri, hiddenState: hiddenState);
  }

  Future<void> push(Route route) {
    return pushUri(route.uri, hiddenState: route.hiddenState);
  }

  Future<void> pushLocation(String location, {Map<String, dynamic> hiddenState = const {}}) {
    return pushUri(Uri.parse(location), hiddenState: hiddenState);
  }

  Future<void> pushReplacementUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) {
    return PondApp.router.pushReplacementUri(uri, hiddenState: hiddenState);
  }

  Future<void> pushReplacement(Route route) {
    return pushReplacementUri(route.uri, hiddenState: route.hiddenState);
  }

  Future<void> pushReplacementLocation(String location, {Map<String, dynamic> hiddenState = const {}}) {
    return pushReplacementUri(Uri.parse(location), hiddenState: hiddenState);
  }

  Future<void> warpToUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) {
    return PondApp.router.warpToUri(uri, hiddenState: hiddenState);
  }

  Future<void> warpTo(Route route) {
    return warpToUri(route.uri, hiddenState: route.hiddenState);
  }

  Future<void> warpToLocation(String location, {Map<String, dynamic> hiddenState = const {}}) {
    return warpToUri(Uri.parse(location), hiddenState: hiddenState);
  }

  void pop() {
    return PondApp.router.pop();
  }
}
