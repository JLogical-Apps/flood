import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';

abstract class AppPage extends HookWidget with IsRoute, IsPathDefinitionWrapper {
  const AppPage({super.key});

  AppPage copy();

  AppPage? getParent() {
    return null;
  }
}
