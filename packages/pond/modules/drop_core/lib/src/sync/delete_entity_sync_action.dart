import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/repository/device_sync_cache_repository.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/sync/sync_action.dart';
import 'package:utils_core/utils_core.dart';

class DeleteEntitySyncAction extends SyncAction {
  static const stateField = 'state';
  late final stateProperty = field<State>(name: stateField).required();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    creationTime(),
    stateProperty,
  ];

  @override
  Future<void> onPublish(DropCoreContext context) async {
    final state = stateProperty.value;
    await context
        .delete(state.withMetadata(state.metadata.copy()..set(forceSourceUpdateField, true)))
        .timeout(Duration(seconds: 4));
  }

  @override
  void modifyStates(List<State> states) {
    states.removeWhere((state) => state.id == stateProperty.value.id!);
  }

  @override
  bool modifies(State state) {
    return state.id == stateProperty.value.id!;
  }
}
