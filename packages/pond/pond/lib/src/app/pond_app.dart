import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';

class PondApp extends HookWidget {
  final FutureOr<AppPondContext> Function() appPondContextGetter;
  final void Function(BuildContext context, AppPondContext appContext) onFinishedLoading;

  const PondApp({
    super.key,
    required this.appPondContextGetter,
    required this.onFinishedLoading,
  });

  @override
  Widget build(BuildContext context) {
    final appContextState = useState<AppPondContext?>(null);
    return MaterialApp(
      home: _wrapByComponents(
        appContext: appContextState.value,
        appComponents: appContextState.value?.appComponents,
        child: Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => PondBody(
                    appPondContextGetter: appPondContextGetter,
                    onFinishedLoading: (context, appContext) {
                      appContextState.value = appContext;
                      onFinishedLoading(context, appContext);
                    },
                  )),
        ),
      ),
    );
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

class PondBody extends HookWidget {
  final FutureOr<AppPondContext> Function() appPondContextGetter;
  final void Function(BuildContext buildContext, AppPondContext appContext) onFinishedLoading;

  const PondBody({super.key, required this.appPondContextGetter, required this.onFinishedLoading});

  @override
  Widget build(BuildContext context) {
    final appContextState = useState<AppPondContext?>(null);
    final doneLoading = appContextState.value != null;

    useMemoized(() => () async {
          final appContext = await appPondContextGetter();
          await appContext.load();
          appContextState.value = appContext;
          onFinishedLoading(context, appContext);
        }());

    return Scaffold(
      body: Center(
        child: doneLoading ? Text('Done!') : Text('Loading...'),
      ),
    );
  }
}
