import 'dart:async';

import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/value_object/time/creation_time_property.dart';
import 'package:drop_core/src/repository/device_sync_cache_repository.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/sync/delete_asset_sync_action.dart';
import 'package:drop_core/src/sync/delete_asset_sync_action_entity.dart';
import 'package:drop_core/src/sync/delete_entity_sync_action.dart';
import 'package:drop_core/src/sync/delete_entity_sync_action_entity.dart';
import 'package:drop_core/src/sync/sync_action.dart';
import 'package:drop_core/src/sync/sync_action_entity.dart';
import 'package:drop_core/src/sync/update_entity_sync_action.dart';
import 'package:drop_core/src/sync/update_entity_sync_action_entity.dart';
import 'package:drop_core/src/sync/upload_asset_sync_action.dart';
import 'package:drop_core/src/sync/upload_asset_sync_action_entity.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

const refreshDuration = Duration(minutes: 1);

class SyncCoreComponent with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forAbstractType<SyncActionEntity, SyncAction>(
    entityTypeName: 'SyncActionEntity',
    valueObjectTypeName: 'SyncAction',
  )
      .withImplementation<UpdateEntitySyncActionEntity, UpdateEntitySyncAction>(
        UpdateEntitySyncActionEntity.new,
        UpdateEntitySyncAction.new,
        entityTypeName: 'UpdateEntitySyncActionEntity',
        valueObjectTypeName: 'UpdateEntitySyncAction',
      )
      .withImplementation<DeleteEntitySyncActionEntity, DeleteEntitySyncAction>(
        DeleteEntitySyncActionEntity.new,
        DeleteEntitySyncAction.new,
        entityTypeName: 'DeleteEntitySyncActionEntity',
        valueObjectTypeName: 'DeleteEntitySyncAction',
      )
      .withImplementation<UploadAssetSyncActionEntity, UploadAssetSyncAction>(
        UploadAssetSyncActionEntity.new,
        UploadAssetSyncAction.new,
        entityTypeName: 'UploadAssetSyncActionEntity',
        valueObjectTypeName: 'UploadAssetSyncAction',
      )
      .withImplementation<DeleteAssetSyncActionEntity, DeleteAssetSyncAction>(
        DeleteAssetSyncActionEntity.new,
        DeleteAssetSyncAction.new,
        entityTypeName: 'DeleteAssetSyncActionEntity',
        valueObjectTypeName: 'DeleteAssetSyncAction',
      )
      .adaptingToDevice('sync');

  final BehaviorSubject<SyncState> _syncStateX = BehaviorSubject.seeded(SyncState.none);
  late final ValueStream<SyncState> syncStateX = _syncStateX;

  bool publishing = false;
  bool republish = false;
  late StreamSubscription refreshSubscription;

  bool shouldSync(CorePondContext context) {
    return context.environment.isOnline && context.platform != Platform.web;
  }

  Future<List<SyncActionEntity>> getSyncEntities() async {
    return await repository
        .executeQuery(Query.from<SyncActionEntity>().orderByAscending(CreationTimeProperty.field).all());
  }

  @override
  List<CorePondComponentBehavior> get behaviors =>
      repository.behaviors +
      [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            if (shouldSync(context)) {
              refreshSubscription = Stream.periodic(refreshDuration).listen(
                (_) => publish(),
              );
            }
          },
          onReset: (context, _) async {
            if (shouldSync(context)) {
              refreshSubscription.cancel();
            }

            final storageDirectory = context.environmentCoreComponent.fileSystem.storageDirectory;
            await DataSource.static
                .crossDirectory(storageDirectory / DeviceSyncCacheRepository.cacheRootFolder)
                .delete();
          },
        )
      ];

  Future<void> registerAction(SyncActionEntity syncActionEntity) async {
    await repository.updateEntity(syncActionEntity);
    publish();
  }

  Future<void> publish() async {
    if (publishing) {
      republish = true;
      return;
    }

    publishing = true;

    try {
      do {
        republish = false;
        final syncActionEntities = await getSyncEntities();

        if (syncActionEntities.isNotEmpty) {
          _syncStateX.value = SyncState.syncing;
        }

        for (final syncActionEntity in syncActionEntities) {
          await syncActionEntity.value.onPublish(context.dropCoreComponent);
          await repository.delete(syncActionEntity);
        }
      } while (republish);

      _syncStateX.value = SyncState.synced;
    } catch (e) {
      _syncStateX.value = SyncState.error;
      rethrow;
    } finally {
      publishing = false;
    }
  }

  Future<void> deleteChanges() async {
    final syncActionEntities = await repository
        .executeQuery(Query.from<SyncActionEntity>().orderByAscending(CreationTimeProperty.field).all());

    for (final syncActionEntity in syncActionEntities) {
      await repository.delete(syncActionEntity);
    }

    _syncStateX.value = SyncState.synced;
  }
}

extension SyncCorePondContextExtensions on CorePondContext {
  SyncCoreComponent get syncCoreComponent => locate<SyncCoreComponent>();
}

enum SyncState {
  none,
  syncing,
  synced,
  error,
}
