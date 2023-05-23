import 'package:drop_core/src/state/state.dart';

abstract class RepositoryStateHandler {
  Future<State> onUpdate(State state);

  Future<State> onDelete(State state);
}

extension RepositoryStateHandlerExtensions on RepositoryStateHandler {
  Future<State> update(State state) {
    return onUpdate(state);
  }

  Future<State> delete(State state) {
    return onDelete(state);
  }
}

mixin IsRepositoryStateHandler implements RepositoryStateHandler {}

abstract class RepositoryStateHandlerWrapper implements RepositoryStateHandler {
  RepositoryStateHandler get stateHandler;
}

mixin IsRepositoryStateHandlerWrapper implements RepositoryStateHandlerWrapper {
  @override
  Future<State> onUpdate(State state) => stateHandler.update(state);

  @override
  Future<State> onDelete(State state) => stateHandler.delete(state);
}
