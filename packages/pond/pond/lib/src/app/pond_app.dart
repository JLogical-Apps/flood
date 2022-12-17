import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';

class PondApp extends HookWidget {
  final FutureOr<AppPondContext> Function() appPondContextGetter;

  const PondApp({super.key, required this.appPondContextGetter});

  @override
  Widget build(BuildContext context) {
    final appContext = useState<AppPondContext?>(null);
    final appComponents = useState<List<AppPondComponent>?>(null);
    final doneLoading = appComponents.value != null;

    useMemoized(() => () async {
          final context = await appPondContextGetter();
          await context.load();
          appContext.value = context;
          appComponents.value = context.appComponents;
        }());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _wrapByComponents(
        appContext: appContext.value,
        appComponents: appComponents.value,
        child: Scaffold(
          body: Center(child: Text(doneLoading ? 'Done!' : 'Loading...')),
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
