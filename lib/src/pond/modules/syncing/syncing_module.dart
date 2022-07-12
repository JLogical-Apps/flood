import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';

import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../../query/request/query_request.dart';
import '../../record/entity.dart';
import '../../repository/entity_repository.dart';
import '../../state/state.dart';
import '../logging/default_logging_module.dart';
import 'sync_download_action.dart';
import 'sync_publish_action.dart';
import 'syncing_repository.dart';

class SyncingModule extends AppModule {
  final List<SyncDownloadAction> _downloadActions = [];
  final Queue<SyncPublishAction> _publishActionsQueue = Queue();

  /// Register a scope to download when [download] is called.
  void registerQueryDownload(QueryRequest queryRequestGetter()) {
    _downloadActions.add(QuerySyncDownloadAction(queryRequestGetter));
  }

  /// Publish all pending changes to source repositories.
  Future<void> publish() async {
    try {
      while (_publishActionsQueue.isNotEmpty) {
        final syncAction = _publishActionsQueue.first;
        await syncAction.publish();
        _publishActionsQueue.removeFirst();
      }
    } catch (e) {
      logError(e);
    }
  }

  Future<void> download() async {
    await Future.wait(_downloadActions.map((action) => action.download()));
  }

  Future<void> enqueueSave(State state) {
    return enqueueSyncPublishAction(SaveSyncPublishAction(state: state));
  }

  Future<void> enqueueDelete(State state) {
    return enqueueSyncPublishAction(DeleteSyncPublishAction(state: state));
  }

  Future<void> enqueueSyncPublishAction(SyncPublishAction action) async {
    _publishActionsQueue.add(action);
  }

  EntityRepository? getSourceRepositoryRuntimeOrNull(Type entityType) {
    final syncingRepository = AppContext.global.appModules
        .whereType<SyncingRepository>()
        .firstWhereOrNull((repository) => repository.sourceRepository.handledEntityTypes.contains(entityType));
    if (syncingRepository == null) {
      return null;
    }

    return syncingRepository.sourceRepository;
  }

  EntityRepository getSourceRepositoryRuntime(Type entityType) {
    return getSourceRepositoryRuntimeOrNull(entityType) ??
        (throw Exception('Unable to find source repository for entity [$entityType]'));
  }

  EntityRepository? getSourceRepositoryOrNull<E extends Entity>() {
    return getSourceRepositoryRuntimeOrNull(E) ?? (throw Exception('Unable to find source repository for entity [$E]'));
  }

  EntityRepository? getSourceRepositoryByStateOrNull(State state) {
    final typeName = state.type;
    if (typeName == null) {
      return null;
    }

    final stateType = AppContext.global.getTypeByName(typeName);

    final syncingRepository = AppContext.global.appModules
        .whereType<SyncingRepository>()
        .firstWhereOrNull((repository) => repository.sourceRepository.handledEntityTypes.contains(stateType));
    if (syncingRepository == null) {
      return null;
    }

    return syncingRepository.sourceRepository;
  }

  EntityRepository getSourceRepositoryByState(State state) {
    return getSourceRepositoryByStateOrNull(state) ??
        (throw Exception('Unable to find source repository for state [$state]'));
  }
}
