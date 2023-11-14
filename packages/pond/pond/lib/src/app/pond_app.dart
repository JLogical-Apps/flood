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
    required Widget loadingPage,
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
          loadingPage: loadingPage,
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
    required RouteData routeData,
  }) {
    for (final appComponent in appPondContext.appComponents) {
      child = appComponent.wrapPage(appPondContext, child, AppPondPageContext(routeData: routeData));
    }

    return child;
  }
}

class PondRouterDelegate extends RouterDelegate<RouteInformation> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final PondApp app;

  List<MaterialPage> _pages = [];

  bool _isAppPondContextLoaded = false;
  bool _hasAppPondContextStartedLoading = false;

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

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    _pages = [MaterialPage(child: app.loadingPage)];
    warpToUri(configuration.uri);
  }

  Future<void> pushUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) async {
    _pages = _pages + [await _getPageFromRouteData(RouteData.uri(uri, hiddenState: hiddenState))];
    _update();
  }

  Future<void> pushReplacementUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) async {
    _pages.removeLast();
    _pages = _pages + [await _getPageFromRouteData(RouteData.uri(uri, hiddenState: hiddenState))];
    _update();
  }

  Future<void> warpToUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) async {
    _pages = await _getPageChainFromRouteData(RouteData.uri(uri, hiddenState: hiddenState));
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

  Future<MaterialPage> _getPageFromRouteData(RouteData routeData) async {
    final (child, routeDataResult) = await _getAppPageFromRouteData(routeData);
    return MaterialPage(
      key: UniqueKey(),
      child: app.wrapPage(child: child, routeData: routeDataResult),
      name: routeDataResult.uri.toString(),
    );
  }

  Future<List<MaterialPage>> _getPageChainFromRouteData(RouteData routeData) async {
    final routeDataChain = await _getParentRouteDataChain(routeData);
    return Future.wait(routeDataChain.map((routeData) => _getPageFromRouteData(routeData)));
  }

  Future<(Widget, RouteData)> _getAppPageFromRouteData(RouteData routeData) async {
    (Widget, RouteData) buildWithoutRedirect(Widget child) {
      return (child, routeData);
    }

    final uri = routeData.uri;

    if (uri.path == splashRoute) {
      return buildWithoutRedirect(Builder(builder: (context) {
        return SplashPage(
          appPondContext: app.appPondContext,
          hasStartedLoading: _hasAppPondContextStartedLoading,
          onStartedLoading: () => _hasAppPondContextStartedLoading = true,
          onFinishedLoading: () => _isAppPondContextLoaded = true,
          loadingPage: app.loadingPage,
        ).build(context, SplashRoute().fromUri(uri));
      }));
    }

    final matchingPageEntry =
        app.appPondContext.getPages().entries.firstWhereOrNull((entry) => entry.key.matchesPath(uri.toString()));
    if (matchingPageEntry == null) {
      return buildWithoutRedirect(app.notFoundPage);
    }

    final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
    final routeInstance = matchingRoute.fromRouteData(routeData) as Route;

    final redirectRouteData = await guardAsync(
      () => matchingPage.getRedirect(app.appPondContext, routeInstance),
      onException: (error, stackTrace) => app.appPondContext.logError(error, stackTrace),
    );
    if (redirectRouteData != null) {
      return await _getAppPageFromRouteData(redirectRouteData);
    }

    return buildWithoutRedirect(Builder(builder: (context) => matchingPage.build(context, routeInstance)));
  }

  Future<List<RouteData>> _getParentRouteDataChain(RouteData routeData) async {
    final uri = routeData.uri;

    if (!_isAppPondContextLoaded) {
      return [(SplashRoute()..redirectProperty.set(uri.toString())).routeData];
    }
    if (uri.path == splashRoute) {
      return [RouteData.uri(uri)];
    }

    final routeDatas = [routeData];
    while (true) {
      final currentRouteData = routeDatas.first;
      final matchingPageEntry = app.appPondContext
          .getPages()
          .entries
          .firstWhereOrNull((entry) => entry.key.matchesRouteData(currentRouteData));
      if (matchingPageEntry == null) {
        throw Exception('Could not find page [$currentRouteData]');
      }

      final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
      final routeInstance = matchingRoute.fromRouteData(currentRouteData) as Route;

      final parentRoute = await guardAsync(
        () => matchingPage.getParent(app.appPondContext, routeInstance),
        onException: (error, stackTrace) => app.appPondContext.logError(error, stackTrace),
      );
      if (parentRoute == null) {
        break;
      }

      routeDatas.insert(0, parentRoute.routeData);
    }

    return routeDatas;
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
