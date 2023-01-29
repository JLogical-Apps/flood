import 'dart:async';

import 'package:actions_core/src/action_runner.dart';
import 'package:actions_core/src/action_runner_setup.dart';

abstract class Action<P, R> implements IsActionRunnerWrapper<P, R> {
  String get name;
}

extension ActionExtensions<P, R> on Action<P, R> {
  Future<R> call(P parameters) => run(parameters);

  Action<P, R> withAdditionalSetup({
    FutureOr Function(P parameters)? onCall,
    FutureOr Function(P parameters, R output)? onCalled,
    FutureOr Function(P parameters, dynamic exception, StackTrace stackTrace)? onFailed,
  }) {
    return ActionWrapper(
      action: this,
      overrideActionRunner: ActionRunnerSetup(
        actionRunner: actionRunner,
        onCall: onCall,
        onCalled: onCalled,
        onFailed: onFailed,
      ),
    );
  }
}

mixin IsAction<P, R> implements Action<P, R> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}

abstract class ActionWrapper<P, R> implements Action<P, R> {
  Action<P, R> get action;

  factory ActionWrapper({
    required Action<P, R> action,
    ActionRunner<P, R>? overrideActionRunner,
  }) =>
      _ActionWrapperImpl(
        action: action,
        overrideActionRunner: overrideActionRunner,
      );
}

mixin IsActionWrapper<P, R> implements ActionWrapper<P, R> {
  @override
  String get name => action.name;

  @override
  Future<R> run(P parameters) => action.run(parameters);

  @override
  ActionRunner<P, R> get actionRunner => action.actionRunner;
}

class _ActionWrapperImpl<P, R> with IsActionWrapper<P, R> {
  @override
  final Action<P, R> action;

  final ActionRunner<P, R>? overrideActionRunner;

  _ActionWrapperImpl({required this.action, this.overrideActionRunner});

  @override
  ActionRunner<P, R> get actionRunner => overrideActionRunner ?? super.actionRunner;

  @override
  Future<R> run(P parameters) {
    return actionRunner.run(parameters);
  }
}
