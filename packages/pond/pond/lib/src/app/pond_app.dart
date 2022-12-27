import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';
import 'package:utils_core/utils_core.dart';

const splashRoute = '/_splash';

class PondApp extends HookWidget {
  final FutureOr<AppPondContext> Function() appPondContextGetter;
  final AppPage Function(BuildContext context, AppPondContext appContext) initialPageGetter;
  final Widget splashPage;

  PondApp({
    super.key,
    required this.appPondContextGetter,
    required this.initialPageGetter,
    required this.splashPage,
  });

  @override
  Widget build(BuildContext context) {
    final appContextState = useState<AppPondContext?>(null);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        if (widget == null) {
          return Container();
        }
        return _wrapByComponents(
          child: widget,
          appContext: appContextState.value,
          appComponents: appContextState.value?.appComponents,
        );
      },
      initialRoute: splashRoute,
      onGenerateInitialRoutes: (path) {
        return [
          getRouteFromPath(path: path, appContextState: appContextState)!,
        ];
      },
      onGenerateRoute: (settings) {
        return getRouteFromPath(path: settings.name, appContextState: appContextState);
      },
    );
  }

  flutter.Route? getRouteFromPath({
    required String? path,
    required ValueNotifier<AppPondContext?> appContextState,
  }) {
    print(path);
    final uri = path?.mapIfNonNull(Uri.tryParse);
    if (uri?.path == splashRoute) {
      print(path);
      return getRoute(
        splashRoute,
        SplashPage(
          appPondContextGetter: appPondContextGetter,
          onFinishedLoading: (context, appContext) {
            appContextState.value = appContext;
            final redirectUri = uri?.queryParameters['redirect'];
            final initialPage = initialPageGetter(context, appContext);
            Navigator.of(context).pushReplacementNamed(redirectUri ?? initialPage.uri.toString());
          },
          splashPage: splashPage,
        ),
      );
    }

    final appContext = appContextState.value;
    if (appContext == null) {
      print(path);
      return getRoute(
        Uri(path: splashRoute, queryParameters: {'redirect': path}).toString(),
        SplashPage(
          appPondContextGetter: appPondContextGetter,
          onFinishedLoading: (context, appContext) {
            appContextState.value = appContext;
            final redirectUri = uri?.queryParameters['redirect'];
            final initialPage = initialPageGetter(context, appContext);
            Navigator.of(context).pushReplacementNamed(redirectUri ?? initialPage.uri.toString());
          },
          splashPage: splashPage,
        ),
      );
    }

    if (path == null) {
      return null;
    }

    final matchingPage = appContext.getPages().firstWhereOrNull((page) => page.matches(path));
    if (matchingPage == null) {
      return null;
    }

    final copy = matchingPage.copy();
    copy.fromPath(path);

    return getRoute(path, copy);
  }

  MaterialPageRoute getRoute(String path, Widget widget) {
    return MaterialPageRoute(builder: (_) => widget, settings: RouteSettings(name: path));
  }

  Widget _wrapByComponents({
    AppPondContext? appContext,
    List<AppPondComponent>? appComponents,
    required Widget child,
  }) {
    if (appComponents == null || appContext == null) {
      return child;
    }

    for (final appComponent in appComponents) {
      child = appComponent.wrapApp(appContext, child);
    }

    return child;
  }
}

class SplashPage extends HookWidget {
  final FutureOr<AppPondContext> Function() appPondContextGetter;
  final void Function(BuildContext buildContext, AppPondContext appContext) onFinishedLoading;
  final Widget splashPage;

  const SplashPage({
    super.key,
    required this.appPondContextGetter,
    required this.onFinishedLoading,
    required this.splashPage,
  });

  @override
  Widget build(BuildContext context) {
    final appContextState = useState<AppPondContext?>(null);

    useMemoized(() => () async {
          final appContext = await appPondContextGetter();
          await appContext.load();
          appContextState.value = appContext;
          onFinishedLoading(context, appContext);
        }());

    return splashPage;
  }
}
