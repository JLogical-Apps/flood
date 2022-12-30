import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/app/page/vrouter_segment_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';
import 'package:vrouter/vrouter.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  final AppPondContext appPondContext;
  final FutureOr<AppPage> Function() initialPageGetter;
  final Widget splashPage;
  final Widget notFoundPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialPageGetter,
    required this.splashPage,
    required this.notFoundPage,
  });

  @override
  Widget build(BuildContext context) {
    final isAppContextLoadedValue = useMutable(() => false);

    return VRouter(
      routes: [
        VGuard(
          beforeEnter: (vRedirector) async => isAppContextLoadedValue.value
              ? vRedirector.to(VRouterSegmentWrapper.getVRouterPath(await initialPageGetter()))
              : null,
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
                        final initialPage = await initialPageGetter();
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
                  !isAppContextLoadedValue.value
                      ? vRedirector.to(Uri(
                          path: splashRoute,
                          queryParameters: uri?.mapIfNonNull((uri) => {redirectParam: uri.toString()}),
                        ).toString())
                      : null;
                },
                stackedRoutes: [
                  getVElementForPage(page),
                ],
              ),
            ),
        VWidget.builder(
          path: '/*',
          builder: (context, state) => notFoundPage,
        ),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return Provider<AppPondContext>(
          create: (_) => appPondContext,
          child: _wrapByComponents(
            child: widget,
            appContext: appPondContext,
          ),
        );
      },
    );
  }

  VRouteElement getVElementForPage(AppPage page) {
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
          beforeEnter: (vRedirector) async {
            final path = vRedirector.toUrl;
            if (path == null) {
              return;
            }

            late AppPage displayedPage;
            if (page.matches(path)) {
              displayedPage = page.copy()..fromPath(path);
            } else {
              final matchingPage = appPondContext.getPages().firstWhere((page) => page.matches(path));
              displayedPage =
                  matchingPage.getParentChain().firstWhere((parent) => parent.runtimeType == page.runtimeType);
            }

            final redirect = await displayedPage.redirectTo(Uri.parse(path));
            if (redirect == null) {
              return;
            }

            vRedirector.to(redirect.uri.toString());
          },
          stackedRoutes: [
            VWidget.builder(
              path: VRouterSegmentWrapper.getVRouterPath(page),
              builder: (context, state) {
                final path = state.path!;
                if (page.matches(path)) {
                  return page.copy()..fromPath(path);
                }

                final matchingPage = appPondContext.getPages().firstWhere((page) => page.matches(path));
                return matchingPage.getParentChain().firstWhere((parent) => parent.runtimeType == page.runtimeType);
              },
              stackedRoutes: appPondContext
                  .getPages()
                  .where((p) => p.getParent()?.runtimeType == page.runtimeType)
                  .map((page) => getVElementForPage(page))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _wrapByComponents({
    required AppPondContext appContext,
    required Widget child,
  }) {
    for (final appComponent in appContext.appComponents) {
      child = appComponent.wrapApp(appContext, child);
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
