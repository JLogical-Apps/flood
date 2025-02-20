import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/repository/lifecycle_state_handler.dart';
import 'package:drop_core/src/state/state.dart';

abstract class RepositoryStateHandler {
  Future<State> onUpdate(State state);

  Future<List<State>> onUpdateAll(List<State> states);

  Future<State> onDelete(State state);

  Future<List<State>> onDeleteAll(List<State> states);
}

extension RepositoryStateHandlerExtensions on RepositoryStateHandler {
  Future<State> update(State state) {
    return onUpdate(state);
  }

  Future<List<State>> updateAll(List<State> states) {
    return onUpdateAll(states);
  }

  Future<State> delete(State state) {
    return onDelete(state);
  }

  Future<List<State>> deleteAll(List<State> states) {
    return onDeleteAll(states);
  }

  RepositoryStateHandler withEntityStateLifecycle(DropCoreContext context) {
    return LifecycleStateHandler(context: context, stateHandler: this);
  }
}

mixin IsRepositoryStateHandler implements RepositoryStateHandler {
  @override
  Future<List<State>> onUpdateAll(List<State> states) async {
    final updatedStates = <State>[];
    for (final state in states) {
      updatedStates.add(await update(state));
    }

    return updatedStates;
  }

  @override
  Future<List<State>> onDeleteAll(List<State> states) async {
    final deletedStates = <State>[];
    for (final state in states) {
      deletedStates.add(await delete(state));
    }

    return deletedStates;
  }
}

abstract class RepositoryStateHandlerWrapper implements RepositoryStateHandler {
  RepositoryStateHandler get stateHandler;
}

mixin IsRepositoryStateHandlerWrapper implements RepositoryStateHandlerWrapper {
  @override
  Future<State> onUpdate(State state) => stateHandler.update(state);

  @override
  Future<List<State>> onUpdateAll(List<State> states) => stateHandler.updateAll(states);

  @override
  Future<State> onDelete(State state) => stateHandler.delete(state);

  @override
  Future<List<State>> onDeleteAll(List<State> states) => stateHandler.deleteAll(states);
}
