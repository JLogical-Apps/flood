import 'dart:async';

import 'package:actions_core/src/action_runner.dart';
import 'package:actions_core/src/action_runner_setup.dart';

abstract class Action<R, P> implements IsActionRunnerWrapper<R, P> {
  String get name;

  factory Action({required String name, required ActionRunner<R, P> actionRunner}) =>
      _ActionImpl(name: name, actionRunner: actionRunner);

  factory Action.fromRunner({required String name, required FutureOr<R> Function(P parameters) runner}) =>
      _ActionImpl(name: name, actionRunner: ActionRunner(runner: runner));
}

extension ActionExtensions<R, P> on Action<R, P> {
  Future<R> call(P parameters) => run(parameters);

  Action<R, P> withActionRunner(ActionRunner<R, P> actionRunner) {
    return Action(name: name, actionRunner: actionRunner);
  }

  Action<R, P> withAdditionalSetup({
    FutureOr Function(P parameters)? onCall,
    FutureOr Function(P parameters, R output)? onCalled,
    FutureOr Function(P parameters, dynamic exception, StackTrace stackTrace)? onFailed,
  }) {
    return withActionRunner(ActionRunnerSetup(
      actionRunner: actionRunner,
      onCall: onCall,
      onCalled: onCalled,
      onFailed: onFailed,
    ));
  }
}

mixin IsAction<R, P> implements Action<R, P> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}

class _ActionImpl<R, P> with IsAction<R, P> {
  @override
  final String name;

  @override
  final ActionRunner<R, P> actionRunner;

  _ActionImpl({required this.name, required this.actionRunner});
}

abstract class ActionWrapper<R, P> implements Action<R, P> {
  Action<R, P> get action;
}

mixin IsActionWrapper<R, P> implements ActionWrapper<R, P> {
  @override
  String get name => action.name;

  @override
  Future<R> run(P parameters) => action.run(parameters);
}
