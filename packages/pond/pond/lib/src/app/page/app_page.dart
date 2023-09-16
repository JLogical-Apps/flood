import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_core/path_core.dart';

abstract class AppPage<R extends Route> {
  Widget onBuild(BuildContext context, R route);
}

extension AppPageExtensions<R extends Route> on AppPage<R> {
  Widget build(BuildContext context, R route) {
    return HookBuilder(builder: (_) => onBuild(context, route));
  }
}
