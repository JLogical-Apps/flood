abstract class Action<R, P> implements IsActionRunnerWrapper<R, P> {
  String get name;
}

mixin IsAction<R, P> implements Action<R, P> {
  @override
  Future<R> run(P parameters) => actionRunner.run(parameters);
}