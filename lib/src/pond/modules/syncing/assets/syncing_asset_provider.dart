import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_delete_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_delete_sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_upload_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_upload_sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/syncing_module.dart';

import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import '../../asset/asset.dart';
import '../../asset/asset_provider.dart';

/// Connects an asset provider to the syncing system so pending uploads are uploaded.
class SyncingAssetProvider extends AssetProvider {
  final AssetProvider localAssetProvider;

  final AssetProvider sourceAssetProvider;

  SyncingAssetProvider({required this.localAssetProvider, required this.sourceAssetProvider});

  @override
  DataSource<Asset> getDataSource(String id) {
    return _SyncingDataSource(localDataSource: localAssetProvider.getDataSource(id), assetId: id);
  }
}

/// DataSource that enqueues publish actions to the syncing module.
class _SyncingDataSource extends DataSource<Asset> {
  final DataSource<Asset> localDataSource;
  final String assetId;

  late final SyncingModule syncingModule = locate<SyncingModule>();

  _SyncingDataSource({required this.localDataSource, required this.assetId});

  @override
  Future<void> saveData(Asset data) async {
    await localDataSource.saveData(data);
    await syncingModule.enqueueSyncPublishAction(
        AssetUploadSyncPublishActionEntity()..value = (AssetUploadSyncPublishAction.fromAssetId(assetId)));
  }

  @override
  Future<void> delete() async {
    await localDataSource.delete();
    await syncingModule.enqueueSyncPublishAction(
        AssetDeleteSyncPublishActionEntity()..value = (AssetDeleteSyncPublishAction.fromAssetId(assetId)));
  }

  @override
  Future<Asset?> getData() {
    return localDataSource.getData();
  }
}
