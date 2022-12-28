import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  final AppPondContext appPondContext;
  final AppPage Function(BuildContext context) initialPageGetter;
  final Widget splashPage;

  PondApp({
    super.key,
    required this.appPondContext,
    required this.initialPageGetter,
    required this.splashPage,
  });

  @override
  Widget build(BuildContext context) {
    final isAppContextLoaded = useMemoized(() => [false]);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        if (widget == null) {
          return Container();
        }
        return _wrapByComponents(
          child: widget,
          appContext: appPondContext,
        );
      },
      routerConfig: useMemoized(() => GoRouter(
            initialLocation: splashRoute,
            routes: [
              GoRoute(
                path: splashRoute,
                redirect: (context, state) async {
                  if (isAppContextLoaded[0]) {
                    final redirect = state.queryParams[redirectParam];
                    final initialPage = initialPageGetter(context);
                    return redirect ?? initialPage.uri.toString();
                  }
                  return null;
                },
                builder: (context, state) {
                  return SplashPage(
                    key: UniqueKey(),
                    splashPage: splashPage,
                    appPondContext: appPondContext,
                    onFinishedLoading: (context) async {
                      isAppContextLoaded[0] = true;
                      final redirect = state.queryParams[redirectParam];
                      final initialPage = initialPageGetter(context);
                      context.go(redirect ?? initialPage.uri.toString());
                    },
                  );
                },
              ),
              ...appPondContext.getPages().expand((page) => [
                    GoRoute(
                      redirect: (context, state) {
                        if (!isAppContextLoaded[0]) {
                          return Uri(
                            path: splashRoute,
                            queryParameters: {redirectParam: state.fullpath},
                          ).toString();
                        }

                        return null;
                      },
                      path: page.uri.toString(),
                      builder: (context, state) => page,
                    ),
                  ]),
            ],
          )),
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
