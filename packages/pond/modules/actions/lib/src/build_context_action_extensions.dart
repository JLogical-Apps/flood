import 'package:actions_core/actions_core.dart' as action_core;
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension BuildContextActionExtensions on BuildContext {
  Future<R> run<A extends action_core.Action<P, R>, P, R>(A action, P parameters) async {
    return find<action_core.ActionCoreComponent>().run(action, parameters);
  }
}
