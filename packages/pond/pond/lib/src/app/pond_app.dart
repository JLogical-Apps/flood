import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:log/log.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_page_context.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/navigation/navigation_build_context_extensions.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:utils/utils.dart';

const splashRoute = '/_splash';

class PondApp extends HookWidget {
  static late PondRouterDelegate router;
  static Uri get currentUri => Uri.parse(router._pages.last.name!);

  final AppPondContext appPondContext;
  final Route Function() initialRouteGetter;
  final Widget loadingPage;
  final Widget notFoundPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialRouteGetter,
    required this.loadingPage,
    required this.notFoundPage,
  });

  static Future<void> run({
    required FutureOr<AppPondContext> Function() appPondContextGetter,
    required Route Function() initialRouteGetter,
    required Widget splashPage,
    required Widget notFoundPage,
  }) async {
    AppPondContext? appPondContext;
    await runZonedGuarded(
      () async {
        setPathUrlStrategy();
        WidgetsFlutterBinding.ensureInitialized();

        appPondContext = await appPondContextGetter();

        runApp(PondApp(
          appPondContext: appPondContext!,
          initialRouteGetter: initialRouteGetter,
          loadingPage: splashPage,
          notFoundPage: notFoundPage,
        ));
      },
      (Object error, StackTrace stackTrace) {
        if (appPondContext != null) {
          appPondContext!.logError(error, stackTrace);
        } else {
          print(error);
          print(stackTrace);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      final routerConfig = useMemoized(() => RouterConfig(
            routerDelegate: PondRouterDelegate(app: this),
            routeInformationParser: _PondRouteInformationParser(),
            routeInformationProvider: PlatformRouteInformationProvider(
              initialRouteInformation: RouteInformation(
                uri: Uri.parse(WidgetsBinding.instance.platformDispatcher.defaultRouteName),
              ),
            ),
          ));
      return wrapApp(
        child: MaterialApp.router(
          routerConfig: routerConfig,
          debugShowCheckedModeBanner: false,
        ),
      );
    });
  }

  void navigateHome(BuildContext context) {
    context.push(initialRouteGetter());
  }

  Widget wrapApp({required Widget child}) {
    for (final appComponent in appPondContext.appComponents) {
      child = appComponent.wrapApp(appPondContext, child);
    }

    return Provider<PondApp>(
      create: (_) => this,
      child: Provider<AppPondContext>(
        create: (_) => appPondContext,
        child: child,
      ),
    );
  }

  Widget wrapPage({
    required Widget child,
    required Uri uri,
  }) {
    for (final appComponent in appPondContext.appComponents) {
      child = appComponent.wrapPage(appPondContext, child, AppPondPageContext(uri: uri));
    }

    return child;
  }
}

class PondRouterDelegate extends RouterDelegate<RouteInformation> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final PondApp app;

  List<MaterialPage> _pages = [];

  bool _isAppPondContextLoaded = false;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  PondRouterDelegate({required this.app}) {
    PondApp.router = this;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        pop();
        _update();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    _pages = [MaterialPage(child: app.loadingPage)];
    warpToUri(configuration.uri);
  }

  Future<void> pushUri(Uri uri) async {
    _pages = _pages + [await _getPageFromUri(uri)];
    _update();
  }

  Future<void> pushReplacementUri(Uri uri) async {
    _pages.removeLast();
    _pages = _pages + [await _getPageFromUri(uri)];
    _update();
  }

  Future<void> warpToUri(Uri uri) async {
    _pages = await _getPageChainFromUri(uri);
    _update();
  }

  void pop() async {
    _pages = _pages.copy()..removeLast();
    _update();
  }

  void _update() {
    final page = _pages.last;
    final uri = Uri.parse(page.name!);

    app.appPondContext.log('Navigating to $uri');

    SystemNavigator.routeInformationUpdated(uri: uri);
    notifyListeners();
  }

  Future<MaterialPage> _getPageFromUri(Uri uri) async {
    final (child, uriResult) = await _getAppPageFromUri(uri);
    return MaterialPage(
      child: app.wrapPage(child: child, uri: uriResult),
      name: uriResult.toString(),
    );
  }

  Future<List<MaterialPage>> _getPageChainFromUri(Uri uri) async {
    final uriChain = await _getParentUriChain(uri);
    return Future.wait(uriChain.map((uri) => _getPageFromUri(uri)));
  }

  Future<(Widget, Uri)> _getAppPageFromUri(Uri uri) async {
    (Widget, Uri) buildWithoutRedirect(Widget child) {
      return (child, uri);
    }

    if (uri.path == splashRoute) {
      return buildWithoutRedirect(Builder(builder: (context) {
        return SplashPage(
          appPondContext: app.appPondContext,
          onFinishedLoading: () => _isAppPondContextLoaded = true,
          loadingPage: app.loadingPage,
        ).build(context, SplashRoute().fromPath(uri.toString()));
      }));
    }

    final matchingPageEntry =
        app.appPondContext.getPages().entries.firstWhereOrNull((entry) => entry.key.matches(uri.toString()));
    if (matchingPageEntry == null) {
      return buildWithoutRedirect(app.notFoundPage);
    }

    final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
    final routeInstance = matchingRoute.fromPath(uri.toString()) as Route;

    final redirectUri = await matchingPage.getRedirect(app.appPondContext, routeInstance);
    if (redirectUri != null) {
      return await _getAppPageFromUri(redirectUri);
    }

    return buildWithoutRedirect(Builder(builder: (context) => matchingPage.build(context, routeInstance)));
  }

  Future<List<Uri>> _getParentUriChain(Uri uri) async {
    if (!_isAppPondContextLoaded) {
      return [(SplashRoute()..redirectProperty.set(uri.toString())).uri];
    }
    if (uri.path == splashRoute) {
      return [uri];
    }

    final uris = [uri];
    while (true) {
      final currentUri = uris.first;
      final matchingPageEntry =
          app.appPondContext.getPages().entries.firstWhereOrNull((entry) => entry.key.matches(currentUri.toString()));
      if (matchingPageEntry == null) {
        throw Exception('Could not find page [$currentUri]');
      }

      final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
      final routeInstance = matchingRoute.fromPath(currentUri.toString()) as Route;

      final parentRoute = await matchingPage.getParent(app.appPondContext, routeInstance);
      if (parentRoute == null) {
        break;
      }

      uris.insert(0, parentRoute.uri);
    }

    return uris;
  }
}

class _PondRouteInformationParser extends RouteInformationParser<RouteInformation> {
  @override
  Future<RouteInformation> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    return SynchronousFuture(routeInformation);
  }
}
