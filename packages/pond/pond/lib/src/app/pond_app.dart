import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';
import 'package:pond/src/app/page/go_router_segment_wrapper.dart';
import 'package:utils/utils.dart';

const splashRoute = '/_splash';
const redirectParam = 'redirect';

class PondApp extends HookWidget {
  final AppPondContext appPondContext;
  final FutureOr<AppPage> Function(BuildContext context) initialPageGetter;
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
    final isAppContextLoaded = isAppContextLoadedValue.value;

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
      routeInformationParser: useMemoized(() => BeamerParser()),
      routerDelegate: useMemoized(() => BeamerDelegate(
            initialPath: splashRoute,
            preferUpdate: true,
            removeDuplicateHistory: false,
            locationBuilder: (state) {
              final path = state.uri.toString();
              if (path == splashRoute) {
                return SplashPageBeamLocation(
                  page: (state) => SplashPage(
                    key: UniqueKey(),
                    splashPage: splashPage,
                    appPondContext: appPondContext,
                    onFinishedLoading: isAppContextLoaded
                        ? null
                        : (context) async {
                            // isAppContextLoadedValue.value = true;
                            final redirect = state.queryParameters[redirectParam];
                            final initialPage = await initialPageGetter(context);
                            context.beamToNamed(redirect ?? initialPage.uri.toString());
                          },
                  ),
                );
              }

              final matchingPage = appPondContext.getPages().firstWhereOrNull((page) => page.matches(path));
              if (matchingPage == null) {
                return NotFound();
              }

              return AppPageBeamLocation(page: matchingPage, location: state.uri.toString());
            },
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

class SplashPageBeamLocation extends BeamLocation<BeamState> {
  final SplashPage Function(BeamState state) page;

  SplashPageBeamLocation({required this.page});

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey(pathBlueprints[0]),
        child: page(state),
        title: '${page.runtimeType}',
      ),
    ];
  }

  @override
  List<Pattern> get pathBlueprints => [splashRoute];
}

class AppPageBeamLocation extends BeamLocation<BeamState> {
  final AppPage page;
  final String location;

  AppPageBeamLocation({required this.page, required this.location});

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // final path = state.uri.toString();
    final path = location;

    return [
      BeamPage(
        key: UniqueKey(),
        child: page.copy()..fromPath(path),
        title: '${page.runtimeType}',
      ),
    ];
  }

  @override
  List<Pattern> get pathBlueprints => [GoRouterSegmentWrapper.getGoRoutePath(page)];
}
