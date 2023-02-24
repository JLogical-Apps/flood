import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pond/pond.dart';
import 'package:vrouter/vrouter.dart';

class NavigationAppPondComponent with IsAppPondComponent {
  String getUrl(BuildContext context) {
    return context.vRouter.url;
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
    final page = context.appPondContext.getPages().firstWhere((page) => page.matches(location));
    final newPage = page.copy();
    newPage.fromPath(location);

    SystemNavigator.routeInformationUpdated(location: location);
    return PondApp.navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (_) => PondApp.wrapPage(
        appContext: context.appPondContext,
        child: newPage,
        uri: Uri.parse(location),
      ),
      settings: RouteSettings(name: location),
    ));
  }

  Future<T> pushReplacement<T>(BuildContext context, AppPage page) async {
    SystemNavigator.routeInformationUpdated(location: page.uri.toString());
    return await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => page,
      settings: RouteSettings(name: page.uri.toString()),
    ));
  }
}
