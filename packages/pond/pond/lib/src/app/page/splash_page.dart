import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/navigation/navigation_build_context_extensions.dart';
import 'package:pond/src/app/page/app_page.dart';

class SplashPage with IsAppPageWrapper<SplashRoute> {
  final AppPondContext appPondContext;
  final Widget loadingPage;
  final Function() onFinishedLoading;

  const SplashPage({
    required this.appPondContext,
    required this.loadingPage,
    required this.onFinishedLoading,
  });

  @override
  AppPage<SplashRoute> get appPage => AppPage<SplashRoute>(
        builder: (context, route) {
          useMemoized(() => () async {
                await appPondContext.load();
                onFinishedLoading();
                context.warpToLocation(route.redirectProperty.value ?? '/');
              }());

          return loadingPage;
        },
      );
}

class SplashRoute with IsRoute<SplashRoute> {
  late final redirectProperty = field<String>(name: 'redirect');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_splash');

  @override
  List<RouteProperty> get queryProperties => [redirectProperty];

  @override
  SplashRoute copy() {
    return SplashRoute();
  }
}
