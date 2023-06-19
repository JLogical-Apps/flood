import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/src/app/component/app_pond_page_context.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/app/navigation/navigation_build_context_extensions.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/vrouter_segment_modifier.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';
import 'package:vrouter/vrouter.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final AppPondContext appPondContext;
  final AppPage Function() initialPageGetter;
  final Widget splashPage;
  final Widget notFoundPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialPageGetter,
    required this.splashPage,
    required this.notFoundPage,
  });

  static Future<void> run({
    required FutureOr<AppPondContext> Function() appPondContextGetter,
    required AppPage Function() initialPageGetter,
    required Widget splashPage,
    required Widget notFoundPage,
    Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        final appPondContext = await appPondContextGetter();

        runApp(PondApp(
          appPondContext: appPondContext,
          initialPageGetter: initialPageGetter,
          splashPage: splashPage,
          notFoundPage: notFoundPage,
        ));
      },
      (Object error, StackTrace stackTrace) {
        onError?.call(error, stackTrace);
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
          return VRouter(
            navigatorKey: navigatorKey,
            initialUrl:
                Uri(path: splashRoute, queryParameters: {redirectParam: initialPageGetter().uri.toString()}).toString(),
            routes: [
              VGuard(
                beforeEnter: (vRedirector) async {
                  if (isAppContextLoadedValue.value) {
                    vRedirector.to(VRouterSegmentModifier.getVRouterPath(initialPageGetter()));
                  }
                },
                stackedRoutes: [
                  VWidget.builder(
                    path: splashRoute,
                    builder: (context, state) => SplashPage(
                      splashPage: splashPage,
                      appPondContext: appPondContext,
                      onFinishedLoading: isAppContextLoadedValue.value
                          ? null
                          : (context) async {
                              isAppContextLoadedValue.value = true;
                              final redirect = state.queryParameters[redirectParam];
                              final initialPage = initialPageGetter();
                              context.vRouter.to(redirect ?? initialPage.uri.toString());
                            },
                    ),
                  ),
                ],
              ),
              ...appPondContext.getPages().where((page) => page.getParent() == null).map(
                    (page) => VGuard(
                      beforeEnter: (vRedirector) async {
                        final uri = vRedirector.toUrl?.mapIfNonNull(Uri.tryParse);
                        if (!isAppContextLoadedValue.value) {
                          vRedirector.to(Uri(
                            path: splashRoute,
                            queryParameters: uri?.mapIfNonNull((uri) => {redirectParam: uri.toString()}),
                          ).toString());
                        }
                      },
                      stackedRoutes: [
                        _getVElementForPage(context, page),
                      ],
                    ),
                  ),
              VWidget.builder(
                path: '*',
                builder: (context, state) => notFoundPage,
              ),
            ],
            debugShowCheckedModeBanner: false,
            builder: (context, widget) => wrapPage(
              child: widget,
              appContext: appPondContext,
              uri: context.uri,
            ),
          );
        },
      ),
    );
  }

  VRouteElement _getVElementForPage<A extends AppPage>(BuildContext context, A page) {
    Future checkRedirect(VRedirector vRedirector) async {
      final path = vRedirector.toUrl;
      if (path == null) {
        return;
      }

      late AppPage displayedPage;
      if (page.matches(path)) {
        displayedPage = page.fromPath(path) as AppPage;
      } else {
        final matchingPage = appPondContext.getPages().firstWhere((page) => page.matches(path));
        displayedPage = matchingPage.getParentChain().firstWhere((parent) => parent.runtimeType == page.runtimeType);
      }

      final redirect = await displayedPage.redirectTo(context, Uri.parse(path));
      if (redirect == null) {
        return;
      }

      vRedirector.to(redirect.toString());
    }

    return VPopHandler(
      onPop: (vRedirector) async {
        final exitingUrl = vRedirector.previousVRouterData?.url;
        if (exitingUrl == null) {
          return;
        }

        if (!page.matches(exitingUrl)) {
          return;
        }

        final parent = page.getParent();
        if (parent == null) {
          return;
        }

        vRedirector.to(parent.uri.toString());
      },
      stackedRoutes: [
        VGuard(
          beforeEnter: checkRedirect,
          beforeUpdate: checkRedirect,
          stackedRoutes: [
            VWidget.builder(
              path: VRouterSegmentModifier.getVRouterPath(page),
              builder: (context, state) {
                final path = state.path!;
                if (page.matches(path)) {
                  return page.fromPath(path);
                }

                final matchingPage = appPondContext.getPages().firstWhere((page) => page.matches(path));
                return matchingPage.getParentChain().firstWhere((parent) => parent.runtimeType == page.runtimeType);
              },
              stackedRoutes: appPondContext
                  .getPages()
                  .where((p) => p.getParent()?.runtimeType == page.runtimeType)
                  .map((page) => _getVElementForPage(context, page))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  void navigateHome(BuildContext context) {
    context.warpTo(initialPageGetter());
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
  final void Function(BuildContext buildContext)? onFinishedLoading;
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
          if (onFinishedLoading == null) {
            return;
          }
          await appPondContext.load();
          onFinishedLoading!(context);
        }());

    return splashPage;
  }
}
