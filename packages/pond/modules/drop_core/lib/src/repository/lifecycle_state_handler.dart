import 'package:collection/collection.dart';
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
    state = entity.getState(context).withMetadata(state.metadata);

    final id = state.id ?? Uuid().v4();
    entity.id = id;
    state = state.withId(id);

    state = await stateHandler.update(state);
    entity.value.setState(context, state);
    entity.isNew = false;

    if (isNew) {
      await entity.afterCreate(context);
    }

    await entity.afterSave(context);

    state = entity.getState(context).withMetadata(state.metadata);

    return state;
  }

  @override
  Future<List<State>> onUpdateAll(List<State> states) async {
    final lifecycledStates = await Future.wait(states.map((state) async {
      final isNew = state.isNew;

      final entity = await context.constructEntityFromState(state);
      if (isNew) {
        await entity.beforeCreate(context);
      }

      await entity.beforeSave(context);
      state = entity.getState(context).withMetadata(state.metadata);

      final id = state.id ?? Uuid().v4();
      entity.id = id;
      return state.withId(id);
    }));

    await stateHandler.updateAll(lifecycledStates);

    return await Future.wait(lifecycledStates.mapIndexed((i, state) async {
      final oldState = states[i];
      final entity = await context.constructEntityFromState(state);

      entity.value.setState(context, state);
      entity.isNew = false;

      if (oldState.isNew) {
        await entity.afterCreate(context);
      }

      await entity.afterSave(context);
      return entity.getState(context).withMetadata(state.metadata);
    }));
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

  @override
  Future<List<State>> onDeleteAll(List<State> states) async {
    final entities = await Future.wait(states.map((state) async {
      final entity = await context.constructEntityFromState(state);
      await entity.beforeDelete(context);
      return entity;
    }));

    await stateHandler.deleteAll(states);

    return Future.wait(entities.map((entity) async {
      await entity.afterDelete(context);
      return entity.getState(context);
    }));
  }
}
