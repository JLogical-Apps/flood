import 'dart:async';

import 'package:path_core/path_core.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/page/app_page.dart';

class AppPageAdditional<R extends Route> with IsAppPageWrapper<R> {
  @override
  final AppPage<R> appPage;

  FutureOr<Route?> Function(AppPondContext context, R route)? parentGetter;

  AppPageAdditional({required this.appPage, this.parentGetter});

  @override
  Future<Route?> getParent(AppPondContext context, R route) async {
    if (parentGetter == null) {
      return await super.getParent(context, route);
    }

    return await parentGetter!(context, route);
  }
}
