abstract class ActionRunner<R, P> {
  Future<R> run(P parameters);
}

mixin IsActionRunner<R, P> implements ActionRunner<R, P> {
}

abstract class ActionRunnerWrapper<R, P> implements ActionRunner<R, P> {
  ActionRunner<R, P> get actionRunner;
}

mixin IsActionRunnerWrapper<R, P> implements ActionRunnerWrapper<R, P> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}