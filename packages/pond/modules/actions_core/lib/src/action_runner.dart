import 'dart:async';

abstract class ActionRunner<R, P> {
  Future<R> run(P parameters);

  factory ActionRunner({required FutureOr<R> Function(P parameters) runner}) => _ActionRunnerImpl(runner: runner);
}

mixin IsActionRunner<R, P> implements ActionRunner<R, P> {}

class _ActionRunnerImpl<R, P> with IsActionRunner<R, P> {
  final FutureOr<R> Function(P parameters) runner;

  _ActionRunnerImpl({required this.runner});

  @override
  Future<R> run(P parameters) async {
    return await runner(parameters);
  }
}

abstract class ActionRunnerWrapper<R, P> implements ActionRunner<R, P> {
  ActionRunner<R, P> get actionRunner;
}

mixin IsActionRunnerWrapper<R, P> implements ActionRunnerWrapper<R, P> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}
