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
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  static Uri location = Uri.parse('_splash');
  static late PondRouterDelegate router;

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

class SplashPage extends HookWidget {
  final AppPondContext appPondContext;
  final void Function(BuildContext buildContext) onFinishedLoading;
  final Widget loadingPage;

  const SplashPage({
    super.key,
    required this.appPondContext,
    required this.onFinishedLoading,
    required this.loadingPage,
  });

  @override
  Widget build(BuildContext context) {
    useMemoized(() => () async {
          await appPondContext.load();
          onFinishedLoading(context);
        }());

    return loadingPage;
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
    warpToUri(configuration.uri);
  }

  Future<void> pushUri(Uri uri) async {
    _pages = _pages + [_getPageFromUri(uri)];
    _update();
  }

  Future<void> pushReplacementUri(Uri uri) async {
    _pages.removeLast();
    _pages = _pages + [_getPageFromUri(uri)];
    _update();
  }

  Future<void> warpToUri(Uri uri) async {
    _pages = [_getPageFromUri(uri)];
    _update();
  }

  void pop() async {
    _pages.removeLast();
    _update();
  }

  void _update() {
    final page = _pages.last;
    final uri = Uri.parse(page.name!);

    app.appPondContext.log('Navigating to $uri');

    SystemNavigator.routeInformationUpdated(uri: uri);
    notifyListeners();
  }

  MaterialPage _getPageFromUri(Uri uri) {
    return MaterialPage(
      child: app.wrapPage(child: _getAppPageFromUri(uri), uri: uri),
      name: uri.toString(),
    );
  }

  Widget _getAppPageFromUri(Uri uri) {
    if (!_isAppPondContextLoaded) {
      return SplashPage(
        appPondContext: app.appPondContext,
        onFinishedLoading: (context) {
          _isAppPondContextLoaded = true;
          context.warpToUri(uri);
        },
        loadingPage: app.loadingPage,
      );
    }

    final matchingPageEntry =
        app.appPondContext.getPages().entries.firstWhereOrNull((entry) => entry.key.matches(uri.toString()));
    if (matchingPageEntry == null) {
      return app.notFoundPage;
    }

    final (matchingRoute, matchingPage) = (matchingPageEntry.key, matchingPageEntry.value);
    final routeInstance = matchingRoute.fromPath(uri.toString()) as Route;

    return Builder(builder: (context) => matchingPage.build(context, routeInstance));
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
