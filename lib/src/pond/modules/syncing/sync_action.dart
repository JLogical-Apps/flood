import 'package:jlogical_utils/src/pond/modules/syncing/syncing_module.dart';

import '../../context/app_context.dart';
import '../../state/state.dart';

abstract class SyncAction {
  final State state;

  SyncAction({required this.state});

  /// Action to perform when publishing this sync action to a source repository.
  Future<void> publish();
}

class SaveSyncAction extends SyncAction {
  SaveSyncAction({required super.state});

  @override
  Future<void> publish() async {
    final sourceRepository = locate<SyncingModule>().getSourceRepositoryByState(state);
    await sourceRepository.saveState(state);
  }
}

class DeleteSyncAction extends SyncAction {
  DeleteSyncAction({required super.state});

  @override
  Future<void> publish() async {
    final sourceRepository = locate<SyncingModule>().getSourceRepositoryByState(state);
    await sourceRepository.deleteState(state);
  }
}
