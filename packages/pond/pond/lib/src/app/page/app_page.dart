import 'dart:async';

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/app/page/app_page_additional.dart';

abstract class AppPage<R extends Route> {
  Widget onBuild(BuildContext context, R route);

  FutureOr<Route?> getParent(AppPondContext context, R route);

  FutureOr<Uri?> getRedirect(AppPondContext context, R route);

  factory AppPage({required Widget Function(BuildContext context, R route) builder}) {
    return _AppPageImpl(builder: builder);
  }
}

extension AppPageExtensions<R extends Route> on AppPage<R> {
  Widget build(BuildContext context, R route) {
    return HookBuilder(
      key: ValueKey(route),
      builder: (_) => onBuild(context, route),
    );
  }

  AppPage<R> withParent(FutureOr<Route?> Function(AppPondContext context, R route) parentGetter) {
    return AppPageAdditional(appPage: this, parentGetter: parentGetter);
  }

  AppPage<R> withRedirect(FutureOr<Uri?> Function(AppPondContext context, R route) redirectGetter) {
    return AppPageAdditional(appPage: this, redirectGetter: redirectGetter);
  }
}

mixin IsAppPage<R extends Route> implements AppPage<R> {
  @override
  FutureOr<Route?> getParent(AppPondContext context, R route) {
    return null;
  }

  @override
  FutureOr<Uri?> getRedirect(AppPondContext context, R route) {
    return null;
  }
}

class _AppPageImpl<R extends Route> with IsAppPage<R> {
  final Widget Function(BuildContext context, R route) builder;

  _AppPageImpl({required this.builder});

  @override
  Widget onBuild(BuildContext context, R route) {
    return builder(context, route);
  }
}

abstract class AppPageWrapper<R extends Route> implements AppPage<R> {
  AppPage<R> get appPage;
}

mixin IsAppPageWrapper<R extends Route> implements AppPageWrapper<R> {
  @override
  Widget onBuild(BuildContext context, R route) => appPage.onBuild(context, route);

  @override
  FutureOr<Route?> getParent(AppPondContext context, R route) => appPage.getParent(context, route);

  @override
  FutureOr<Uri?> getRedirect(AppPondContext context, route) => appPage.getRedirect(context, route);
}
