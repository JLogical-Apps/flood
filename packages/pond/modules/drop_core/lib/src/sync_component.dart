import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/sync/delete_entity_sync_action.dart';
import 'package:drop_core/src/sync/delete_entity_sync_action_entity.dart';
import 'package:drop_core/src/sync/sync_action.dart';
import 'package:drop_core/src/sync/sync_action_entity.dart';
import 'package:drop_core/src/sync/update_entity_sync_action.dart';
import 'package:drop_core/src/sync/update_entity_sync_action_entity.dart';
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
      .adaptingToDevice('sync');

  final BehaviorSubject<SyncState> _syncStateX = BehaviorSubject.seeded(SyncState.syncing);
  late final ValueStream<SyncState> syncStateX = _syncStateX;

  bool publishing = false;
  late StreamSubscription refreshSubscription;

  @override
  List<CorePondComponentBehavior> get behaviors =>
      repository.behaviors +
      [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            refreshSubscription = Stream.periodic(refreshDuration).listen(
              (_) => publish(),
            );
          },
          onReset: (context, _) async {
            refreshSubscription.cancel();
          },
        )
      ];

  Future<void> registerAction(SyncActionEntity syncActionEntity) async {
    await repository.updateEntity(syncActionEntity);
    publish();
  }

  Future<void> publish() async {
    if (publishing) {
      return;
    }

    publishing = true;

    try {
      final syncActionEntities = await repository
          .executeQuery(Query.from<SyncActionEntity>().orderByAscending(CreationTimeProperty.field).all());

      if (syncActionEntities.isNotEmpty) {
        _syncStateX.value = SyncState.syncing;
      }

      for (final syncActionEntity in syncActionEntities) {
        await syncActionEntity.value.onPublish(context.dropCoreComponent);
        await repository.delete(syncActionEntity);
      }

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
  syncing,
  synced,
  error,
}
