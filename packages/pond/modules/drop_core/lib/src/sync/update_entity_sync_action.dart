import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/repository/device_cache_repository.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/sync/sync_action.dart';
import 'package:utils_core/utils_core.dart';

class UpdateEntitySyncAction extends SyncAction {
  static const stateField = 'state';
  late final stateProperty = field<State>(name: stateField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [creationTime(), stateProperty];

  @override
  Future<void> onPublish(DropCoreContext context) async {
    final state = stateProperty.value;
    await context
        .update(state.withMetadata(state.metadata.copy()..set(forceSourceUpdateField, true)))
        .timeout(Duration(seconds: 4));
  }
}
