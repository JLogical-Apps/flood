import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';
import 'package:vrouter/vrouter.dart';

class NavigationAppComponent with IsAppPondComponent {
  String getUrl(BuildContext context) {
    return PondApp.navigatorKey.currentState?.currentPath ?? context.vRouter.url;
  }

  Uri getUri(BuildContext context) {
    return Uri.parse(getUrl(context));
  }

  void warpTo(BuildContext context, AppPage page) {
    context.vRouter.to(page.uri.toString(), historyState: context.vRouter.historyState);
  }

  void warpToLocation(BuildContext context, String location) {
    context.vRouter.to(location, historyState: context.vRouter.historyState);
  }

  Future<T?> push<T>(BuildContext context, AppPage page) async {
    return pushLocation(context, page.uri.toString());
  }

  Future<T?> pushUri<T>(BuildContext context, Uri uri) async {
    return pushLocation<T>(context, uri.toString());
  }

  Future<T?> pushLocation<T>(BuildContext context, String location) async {
    final page = context.appPondContext.getPages().firstWhereOrNull((page) => page.matches(location));
    if (page == null) {
      warpToLocation(context, location);
      return null;
    }

    final newPage = page.fromPath(location);

    final redirectUri = await newPage.redirectTo(context, Uri.parse(location));
    if (redirectUri != null) {
      return pushLocation(context, redirectUri.toString());
    }

    SystemNavigator.routeInformationUpdated(uri: Uri.parse(location));

    final result = await PondApp.navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (_) => PondApp.wrapPage(
        appContext: context.appPondContext,
        child: newPage,
        uri: Uri.parse(location),
      ),
      settings: RouteSettings(name: location),
    ));

    _updateSystemPath();

    return result;
  }

  Future<T> pushReplacement<T>(BuildContext context, AppPage page) async {
    final location = page.uri.toString();
    SystemNavigator.routeInformationUpdated(uri: page.uri);

    final result = await PondApp.navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (_) => page,
      settings: RouteSettings(name: location),
    ));

    return result;
  }

  void pop<T>([T? result]) {
    PondApp.navigatorKey.currentState!.pop(result);
    _updateSystemPath();
  }

  void _updateSystemPath() {
    final path = PondApp.navigatorKey.currentState!.currentPath;
    if (path != null) {
      SystemNavigator.routeInformationUpdated(uri: Uri.parse(path));
    }
  }
}
