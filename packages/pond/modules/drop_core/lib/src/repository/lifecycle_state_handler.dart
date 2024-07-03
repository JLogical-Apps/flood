import 'package:drop_core/drop_core.dart';
import 'package:uuid/uuid.dart';

class LifecycleStateHandler with IsRepositoryStateHandlerWrapper {
  final DropCoreContext context;

  @override
  final RepositoryStateHandler stateHandler;

  LifecycleStateHandler({required this.context, required this.stateHandler});

  @override
  Future<State> onUpdate(State state) async {
    final isNew = state.isNew;

    final entity = await context.constructEntityFromState(state);
    if (isNew) {
      await entity.beforeCreate(context);
    }

    await entity.beforeSave(context);
    state = entity.getState(context);

    final id = state.id ?? Uuid().v4();
    entity.id = id;
    state = state.withId(id);

    state = await stateHandler.update(state);
    entity.value.setState(context, state);

    if (isNew) {
      await entity.afterCreate(context);
    }

    await entity.afterSave(context);

    state = entity.getState(context).withId(id);

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    final entity = await context.constructEntityFromState(state);

    await entity.beforeDelete(context);
    await stateHandler.delete(state);
    await entity.afterDelete(context);

    state = entity.getState(context);

    return state;
  }
}
