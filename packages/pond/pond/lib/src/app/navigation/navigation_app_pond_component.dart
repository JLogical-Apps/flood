import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:vrouter/vrouter.dart';

class NavigationAppPondComponent with IsAppPondComponent {
  void warpTo(BuildContext context, AppPage page) {
    context.vRouter.to(page.uri.toString(), historyState: context.vRouter.historyState);
  }

  Future<T> push<T>(BuildContext context, AppPage page) async {
    SystemNavigator.routeInformationUpdated(location: page.uri.toString());
    return await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => page,
      settings: RouteSettings(name: page.uri.toString()),
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
