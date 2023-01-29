import 'package:actions_core/actions_core.dart';

abstract class ActionContext {
  Action<P, R> wrapAction<P, R>(Action<P, R> action);
}

extension ActionContextExtensions on ActionContext {
  Future<R> run<P, R>(Action<P, R> action, P parameters) async {
    return wrapAction(action).run(parameters);
  }
}

mixin IsActionContext implements ActionContext {
  @override
  Action<P, R> wrapAction<P, R>(Action<P, R> action) {
    return action;
  }
}

abstract class ActionContextWrapper implements ActionContext {
  ActionContext get actionContext;
}

mixin IsActionContextWrapper implements ActionContextWrapper {
  @override
  Action<P, R> wrapAction<P, R>(Action<P, R> action) => actionContext.wrapAction(action);
}
