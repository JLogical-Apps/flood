import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';

abstract class AppPage extends HookWidget with IsRoute, IsPathDefinitionWrapper {
  const AppPage({super.key});

  AppPage copy();

  AppPage? getParent() {
    return null;
  }

  FutureOr<AppPage?> redirectTo(Uri currentUri) {
    return null;
  }

  List<AppPage> getParentChain() {
    final pages = <AppPage>[this];
    AppPage current = this;
    while (current.getParent() != null) {
      current = current.getParent()!;
      pages.add(current);
    }
    return pages;
  }
}
