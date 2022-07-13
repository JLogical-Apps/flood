import '../../../context/app_context.dart';
import '../../../property/map_field_property.dart';
import '../../../property/property.dart';
import '../../../state/state.dart';
import '../syncing_module.dart';
import 'sync_publish_action.dart';

class SaveSyncPublishAction extends SyncPublishAction {
  late final saveStateProperty = MapFieldProperty<String, dynamic>(name: 'state').required();

  State get saveState => State.extractFrom(saveStateProperty.value);

  SaveSyncPublishAction();

  SaveSyncPublishAction.fromSaveState(State saveState) {
    saveStateProperty.value = saveState.fullValues;
  }

  @override
  List<Property> get properties => super.properties + [saveStateProperty];

  @override
  Future<void> publish() async {
    final sourceRepository = locate<SyncingModule>().getSourceRepositoryByState(saveState);
    await sourceRepository.saveState(saveState);
  }
}
