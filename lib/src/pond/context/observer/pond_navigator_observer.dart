import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';

class PondNavigatorObserver extends NavigatorObserver {
  List get observers => AppContext.global.navigatorObservers;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    observers.forEach((observer) => observer.didPop(route, previousRoute));
  }

  @override
  void didStopUserGesture() {
    observers.forEach((observer) => observer.didStopUserGesture());
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    observers.forEach((observer) => observer.didStartUserGesture(route, previousRoute));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    observers.forEach((observer) => observer.didReplace(newRoute: newRoute, oldRoute: oldRoute));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    observers.forEach((observer) => observer.didRemove(route, previousRoute));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    observers.forEach((observer) => observer.didPush(route, previousRoute));
  }
}
