import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';

import '../../record/entity.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../../query/request/query_request.dart';
import '../../state/state.dart';
import '../logging/default_logging_module.dart';
import 'query_download_scope.dart';
import 'sync_action.dart';
import '../../repository/entity_repository.dart';
import 'syncing_repository.dart';

class SyncingModule extends AppModule {
  final List<QueryDownloadScope> _queryDownloads = [];
  final Queue<SyncAction> _syncActionsQueue = Queue();

  static const _initialLoadTimeout = const Duration(seconds: 3);

  Future<void> onLoad(AppRegistration registration) async {
    await Future(() async {
      for (final queryDownload in _queryDownloads) {
        final queryRequest = queryDownload.queryRequestGetter();
        await queryRequest.get();
      }
    }).timeout(_initialLoadTimeout);
  }

  /// Register a scope to download when [download] is called.
  void registerQueryDownload(QueryRequest queryRequestGetter()) {
    _queryDownloads.add(QueryDownloadScope(queryRequestGetter));
  }

  /// Publish all pending changes to source repositories.
  Future<void> publish() async {
    try {
      while (_syncActionsQueue.isNotEmpty) {
        final syncAction = _syncActionsQueue.first;
        await syncAction.publish();
        _syncActionsQueue.removeFirst();
      }
    } catch (e) {
      logError(e);
    }
  }

  /// Download all scopes to local repositories.
  Future<void> download() async {
    for (final queryDownloadScope in _queryDownloads) {
      final queryRequest = queryDownloadScope.getQueryRequest();
      final sourceRepository = getSourceRepositoryRuntime(queryRequest.query.recordType);
      await sourceRepository.executeQuery(queryRequest);
    }
  }

  Future<void> enqueueSave(State state) async {
    _syncActionsQueue.add(SaveSyncAction(state: state));
  }

  Future<void> enqueueDelete(State state) async {
    _syncActionsQueue.add(DeleteSyncAction(state: state));
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
