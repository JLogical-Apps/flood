import '../../../context/app_context.dart';
import '../../../property/map_field_property.dart';
import '../../../property/property.dart';
import '../../../state/state.dart';
import '../syncing_module.dart';
import 'sync_publish_action.dart';

class DeleteSyncPublishAction extends SyncPublishAction {
  late final deleteStateProperty = MapFieldProperty<String, dynamic>(name: 'state').required();

  State get deleteState => State.extractFrom(deleteStateProperty.value);

  DeleteSyncPublishAction();

  DeleteSyncPublishAction.fromDeleteState(State saveState) {
    deleteStateProperty.value = saveState.fullValues;
  }

  @override
  List<Property> get properties => super.properties + [deleteStateProperty];

  @override
  Future<void> publish() async {
    final sourceRepository = locate<SyncingModule>().getSourceRepositoryByState(deleteState);
    await sourceRepository.deleteState(deleteState).timeout(Duration(seconds: 30));
  }
}
