import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/app/page/go_router_segment_wrapper.dart';
import 'package:utils/utils.dart';
import 'package:vrouter/vrouter.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  final AppPondContext appPondContext;
  final FutureOr<AppPage> Function() initialPageGetter;
  final Widget splashPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialPageGetter,
    required this.splashPage,
  });

  @override
  Widget build(BuildContext context) {
    final isAppContextLoadedValue = useMutable(() => false);

    return VRouter(
      routes: [
        VGuard(
          beforeEnter: (vRedirector) async => isAppContextLoadedValue.value
              ? vRedirector.to(GoRouterSegmentWrapper.getGoRoutePath(await initialPageGetter()))
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
        ...appPondContext.getPages().map(
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
                  VWidget.builder(
                    path: GoRouterSegmentWrapper.getGoRoutePath(page),
                    builder: (context, state) => page.copy()..fromPath(state.path!),
                  ),
                ],
              ),
            ),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return _wrapByComponents(
          child: widget,
          appContext: appPondContext,
        );
      },
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
