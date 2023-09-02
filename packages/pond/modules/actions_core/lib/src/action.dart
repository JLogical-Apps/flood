import 'dart:async';

import 'package:actions_core/src/action/log_action.dart';
import 'package:actions_core/src/action_runner.dart';
import 'package:actions_core/src/action_runner_setup.dart';
import 'package:pond_core/pond_core.dart';

abstract class Action<P, R> implements IsActionRunnerWrapper<P, R> {
  String get name;

  factory Action.fromActionRunner({required String name, required ActionRunner<P, R> actionRunner}) =>
      _ActionImpl(name: name, actionRunner: actionRunner);

  factory Action({required String name, required FutureOr<R> Function(P parameters) runner}) =>
      _ActionImpl(name: name, actionRunner: ActionRunner(runner: runner));
}

extension ActionExtensions<P, R> on Action<P, R> {
  Future<R> call(P parameters) => run(parameters);

  Action<P, R> copyWith({String? name, ActionRunner<P, R>? actionRunner}) {
    return Action.fromActionRunner(
      name: name ?? this.name,
      actionRunner: actionRunner ?? this.actionRunner,
    );
  }

  Action<P, R> withAdditionalSetup({
    FutureOr Function(P parameters)? onCall,
    FutureOr Function(P parameters, R output)? onCalled,
    FutureOr Function(P parameters, dynamic exception, StackTrace stackTrace)? onFailed,
  }) {
    return copyWith(
      actionRunner: ActionRunnerSetup(
        actionRunner: actionRunner,
        onCall: onCall,
        onCalled: onCalled,
        onFailed: onFailed,
      ),
    );
  }

  Action<P, R> log({required CorePondContext context}) {
    return LogAction(source: this, context: context);
  }
}

mixin IsAction<P, R> implements Action<P, R> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}

class _ActionImpl<P, R> with IsAction<P, R> {
  @override
  final String name;

  @override
  final ActionRunner<P, R> actionRunner;

  _ActionImpl({required this.name, required this.actionRunner});
}

abstract class ActionWrapper<P, R> implements Action<P, R> {
  Action<P, R> get action;
}

mixin IsActionWrapper<P, R> implements ActionWrapper<P, R> {
  @override
  String get name => action.name;

  @override
  Future<R> run(P parameters) => action.run(parameters);

  @override
  ActionRunner<P, R> get actionRunner => action.actionRunner;
}
