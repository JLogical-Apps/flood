import 'package:actions_core/src/action.dart';
import 'package:actions_core/src/action_context.dart';
import 'package:pond_core/pond_core.dart';

class ActionCoreComponent with IsCorePondComponent, IsActionContext {
  final Action<P, R> Function<P, R>(Action<P, R> action)? actionWrapper;

  ActionCoreComponent({this.actionWrapper});

  @override
  Action<P, R> wrapAction<P, R>(Action<P, R> action) {
    return actionWrapper?.call(action) ?? action;
  }
}
