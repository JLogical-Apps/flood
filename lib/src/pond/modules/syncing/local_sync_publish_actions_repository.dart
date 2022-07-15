import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_delete_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_upload_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/save_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/save_sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/sync_publish_action_entity.dart';

import 'publish_actions/delete_sync_publish_action.dart';
import 'publish_actions/delete_sync_publish_action_entity.dart';

class LocalSyncPublishActionsRepository extends DefaultAbstractLocalRepository<SyncPublishActionEntity, SyncPublishAction> {
  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        ValueObjectRegistration<SyncPublishAction, SyncPublishAction?>.abstract(),
        ValueObjectRegistration<SaveSyncPublishAction, SaveSyncPublishAction?>(
          () => SaveSyncPublishAction(),
          parents: {SyncPublishAction},
        ),
        ValueObjectRegistration<DeleteSyncPublishAction, DeleteSyncPublishAction?>(
          () => DeleteSyncPublishAction(),
          parents: {SyncPublishAction},
        ),
        ValueObjectRegistration<AssetUploadSyncPublishAction, AssetUploadSyncPublishAction?>(
          () => AssetUploadSyncPublishAction(),
          parents: {SyncPublishAction},
        ),
        ValueObjectRegistration<AssetDeleteSyncPublishAction, AssetDeleteSyncPublishAction?>(
          () => AssetDeleteSyncPublishAction(),
          parents: {SyncPublishAction},
        ),
      ];

  @override
  List<EntityRegistration<Entity<ValueObject>, ValueObject>> get entityRegistrations => [
        EntityRegistration<SyncPublishActionEntity, SyncPublishAction>.abstract(),
        EntityRegistration<SaveSyncPublishActionEntity, SaveSyncPublishAction>(() => SaveSyncPublishActionEntity()),
        EntityRegistration<DeleteSyncPublishActionEntity, DeleteSyncPublishAction>(
            () => DeleteSyncPublishActionEntity()),
      ];
}
