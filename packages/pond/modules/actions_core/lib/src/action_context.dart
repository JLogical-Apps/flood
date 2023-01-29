import 'package:actions_core/src/action.dart';
import 'package:collection/collection.dart';

abstract class ActionContext {
  List<Action> get actions;
}

extension ActionContextExtensions on ActionContext {
  Action<P, R>? findActionOrNull<P, R>() {
    return actions.whereType<Action<P, R>>().firstOrNull;
  }

  Action<P, R> findAction<A extends Action<P, R>, P, R>() {
    return findActionOrNull<P, R>() ?? (throw Exception('Cannot find action of [$P, $R]'));
  }
}

mixin IsActionContext implements ActionContext {}

abstract class ActionContextWrapper implements ActionContext {
  ActionContext get actionContext;
}

mixin IsActionContextWrapper implements ActionContextWrapper {
  @override
  List<Action> get actions => actionContext.actions;
}
