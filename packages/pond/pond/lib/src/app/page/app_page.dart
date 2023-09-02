import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';

abstract class AppPage<A extends AppPage<dynamic>> extends HookWidget with IsRoute<A>, IsPathDefinitionWrapper {
  const AppPage({super.key});

  AppPage? getParent() {
    return null;
  }

  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) {
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
