import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/repository/device_sync_cache_repository.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/sync/sync_action.dart';
import 'package:utils_core/utils_core.dart';

class UpdateEntitySyncAction extends SyncAction {
  static const stateField = 'state';
  late final stateProperty = field<State>(name: stateField).required();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    creationTime(),
    stateProperty,
  ];

  @override
  void modifyStates(List<State> states) {
    final index = states.indexWhere((state) => state.id == stateProperty.value.id);
    if (index == -1) {
      states.add(stateProperty.value);
    } else {
      states[index] = stateProperty.value;
    }
  }

  @override
  Future<void> onPublish(DropCoreContext context) async {
    final state = stateProperty.value;
    final entity = await context.constructEntityFromState(state);
    final entityState = entity.getState(context);
    await context
        .update(entityState.withMetadata(state.metadata.copy()..set(forceSourceUpdateField, true)))
        .timeout(Duration(seconds: 4));
  }

  @override
  bool modifies(State state) {
    return state.id == stateProperty.value.id!;
  }
}
