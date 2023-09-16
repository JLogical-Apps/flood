import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_page_context.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/navigation/navigation_build_context_extensions.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final AppPondContext appPondContext;
  final Route Function() initialRouteGetter;
  final Widget splashPage;
  final Widget notFoundPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialRouteGetter,
    required this.splashPage,
    required this.notFoundPage,
  });

  static Future<void> run({
    required FutureOr<AppPondContext> Function() appPondContextGetter,
    required Route Function() initialRouteGetter,
    required Widget splashPage,
    required Widget notFoundPage,
    Function(AppPondContext? appPondContext, Object error, StackTrace stackTrace)? onError,
  }) async {
    AppPondContext? appPondContext;
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        appPondContext = await appPondContextGetter();

        runApp(PondApp(
          appPondContext: appPondContext!,
          initialRouteGetter: initialRouteGetter,
          splashPage: splashPage,
          notFoundPage: notFoundPage,
        ));
      },
      (Object error, StackTrace stackTrace) {
        onError?.call(appPondContext, error, stackTrace);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAppContextLoadedValue = useMutable(() => false);

    return wrapApp(
      pondApp: this,
      appContext: appPondContext,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: (route) => _getRouteFromPath(
              route.name!,
              isAppContextLoaded: isAppContextLoadedValue.value,
              onAppContextLoaded: (_) => isAppContextLoadedValue.value = true,
            ),
            onGenerateInitialRoutes: (route) => [
              _getRouteFromPath(
                route,
                isAppContextLoaded: isAppContextLoadedValue.value,
                onAppContextLoaded: (_) => isAppContextLoadedValue.value = true,
              ),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  flutter.Route _getRouteFromPath(
    String path, {
    required bool isAppContextLoaded,
    required Function(BuildContext context) onAppContextLoaded,
  }) {
    return MaterialPageRoute(
      builder: (context) => wrapPage(
        appContext: appPondContext,
        child: _getPageFromPath(
          context,
          path: path,
          isAppContextLoaded: isAppContextLoaded,
          onAppContextLoaded: onAppContextLoaded,
        ),
        uri: Uri.parse(path),
      ),
      settings: RouteSettings(name: path),
    );
  }

  Widget _getPageFromPath(
    BuildContext context, {
    required String path,
    required bool isAppContextLoaded,
    required Function(BuildContext context) onAppContextLoaded,
  }) {
    final uri = Uri.parse(path);

    if (!isAppContextLoaded) {
      return SplashPage(
        appPondContext: appPondContext,
        onFinishedLoading: (context) {
          onAppContextLoaded(context);
          context.pushReplacementUri(uri);
        },
        splashPage: splashPage,
      );
    }

    final matchingPageEntry =
        appPondContext.getPages().entries.firstWhereOrNull((entry) => entry.key.matches(uri.toString()));
    if (matchingPageEntry == null) {
      return notFoundPage;
    }

    final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
    final routeInstance = matchingRoute.fromPath(uri.toString()) as Route;

    return matchingPage.build(context, routeInstance);
  }

  void navigateHome(BuildContext context) {
    context.push(initialRouteGetter());
  }

  static Widget wrapApp({
    required PondApp pondApp,
    required AppPondContext appContext,
    required Widget child,
  }) {
    for (final appComponent in appContext.appComponents) {
      child = appComponent.wrapApp(appContext, child);
    }

    return Provider<PondApp>(
      create: (_) => pondApp,
      child: Provider<AppPondContext>(
        create: (_) => appContext,
        child: child,
      ),
    );
  }

  static Widget wrapPage({
    required AppPondContext? appContext,
    required Widget child,
    required Uri uri,
  }) {
    if (appContext == null) {
      return child;
    }

    for (final appComponent in appContext.appComponents) {
      child = appComponent.wrapPage(appContext, child, AppPondPageContext(uri: uri));
    }

    return child;
  }
}

class SplashPage extends HookWidget {
  final AppPondContext appPondContext;
  final void Function(BuildContext buildContext) onFinishedLoading;
  final Widget splashPage;

  const SplashPage({
    super.key,
    required this.appPondContext,
    required this.onFinishedLoading,
    required this.splashPage,
  });

  @override
  Widget build(BuildContext context) {
    useMemoized(() => () async {
          await appPondContext.load();
          onFinishedLoading(context);
        }());

    return splashPage;
  }
}

class MultiRoute extends PageRouteBuilder {
  final List<flutter.Route> routes;

  MultiRoute({required this.routes})
      : super(
          pageBuilder: (_, __, ___) => Container(),
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        );

  @override
  TickerFuture didPush() {
    for (final route in routes) {
      Navigator.of(navigator!.context).push(route);
    }
    return super.didPush();
  }
}
