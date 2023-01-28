import 'dart:async';

import 'package:actions_core/src/action_runner.dart';

class ActionRunnerSetup<R, P> with IsActionRunnerWrapper<R, P> {
  @override
  final ActionRunner<R, P> actionRunner;

  FutureOr Function(P parameters)? onCall;
  FutureOr Function(P parameters, R output)? onCalled;
  FutureOr Function(P parameters, dynamic exception, StackTrace stackTrace)? onFailed;

  ActionRunnerSetup({required this.actionRunner, this.onCall, this.onCalled, this.onFailed});

  @override
  Future<R> run(P parameters) async {
    await onCall?.call(parameters);
    try {
      final output = await actionRunner.run(parameters);
      await onCalled?.call(parameters, output);
      return output;
    } catch (e, stackTrace) {
      await onFailed?.call(parameters, e, stackTrace);
      rethrow;
    }
  }
}
