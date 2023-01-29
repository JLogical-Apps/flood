import 'dart:async';

abstract class ActionRunner<P, R> {
  Future<R> run(P parameters);

  factory ActionRunner({required FutureOr<R> Function(P parameters) runner}) => _ActionRunnerImpl(runner: runner);
}

mixin IsActionRunner<P, R> implements ActionRunner<P, R> {}

class _ActionRunnerImpl<P, R> with IsActionRunner<P, R> {
  final FutureOr<R> Function(P parameters) runner;

  _ActionRunnerImpl({required this.runner});

  @override
  Future<R> run(P parameters) async {
    return await runner(parameters);
  }
}

abstract class ActionRunnerWrapper<P, R> implements ActionRunner<P, R> {
  ActionRunner<P, R> get actionRunner;
}

mixin IsActionRunnerWrapper<P, R> implements ActionRunnerWrapper<P, R> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}
