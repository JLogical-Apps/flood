import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';

class PondApp extends HookWidget {
  final AppPondContext appContext;

  const PondApp({super.key, required this.appContext});

  @override
  Widget build(BuildContext context) {
    final appComponents = useState<List<AppPondComponent>?>(null);
    final doneLoading = appComponents.value != null;

    useMemoized(() => () async {
          await appContext.load();
          appComponents.value = appContext.appComponents;
        }());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _wrapByComponents(
        appComponents: appComponents.value,
        child: Scaffold(
          body: Center(child: Text(doneLoading ? 'Done!' : 'Loading...')),
        ),
      ),
    );
  }

  Widget _wrapByComponents({List<AppPondComponent>? appComponents, required Widget child}) {
    if (appComponents == null) {
      return child;
    }

    for (final appComponent in appComponents) {
      child = appComponent.wrapApp(child);
    }

    return child;
  }
}
