import 'package:drop_core/src/state/state.dart';

abstract class RepositoryStateHandler {
  Future<void> onUpdate(State state);

  Future<void> onDelete(State state);
}

extension RepositoryStateHandlerExtensions on RepositoryStateHandler {
  Future<void> update(State state) {
    return onUpdate(state);
  }

  Future<void> delete(State state) {
    return onDelete(state);
  }
}

mixin IsRepositoryStateHandler implements RepositoryStateHandler {}

abstract class RepositoryStateHandlerWrapper implements RepositoryStateHandler {
  RepositoryStateHandler get stateHandler;
}

mixin IsRepositoryStateHandlerWrapper implements RepositoryStateHandlerWrapper {
  @override
  Future<void> onUpdate(State state) => stateHandler.update(state);

  @override
  Future<void> onDelete(State state) => stateHandler.delete(state);
}
