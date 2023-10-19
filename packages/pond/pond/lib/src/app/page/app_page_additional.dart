import 'dart:async';

import 'package:path_core/path_core.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/page/app_page.dart';

class AppPageAdditional<R extends Route> with IsAppPageWrapper<R> {
  @override
  final AppPage<R> appPage;

  FutureOr<Route?> Function(AppPondContext context, R route)? parentGetter;
  FutureOr<RouteData?> Function(AppPondContext context, R route)? redirectGetter;

  AppPageAdditional({
    required this.appPage,
    this.parentGetter,
    this.redirectGetter,
  });

  @override
  Future<Route?> getParent(AppPondContext context, R route) async {
    if (parentGetter == null) {
      return await super.getParent(context, route);
    }

    return await parentGetter!(context, route);
  }

  @override
  Future<RouteData?> getRedirect(AppPondContext context, R route) async {
    final parentRedirect = await super.getRedirect(context, route);
    if (parentRedirect != null) {
      return parentRedirect;
    }

    return await redirectGetter?.call(context, route);
  }
}
