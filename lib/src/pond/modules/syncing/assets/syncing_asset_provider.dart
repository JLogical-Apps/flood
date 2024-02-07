import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_delete_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_delete_sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_upload_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/assets/publish_actions/asset_upload_sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/syncing_module.dart';

import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import '../../../context/registration/app_registration.dart';
import '../../asset/asset.dart';
import '../../asset/asset_metadata.dart';
import '../../asset/asset_provider.dart';

/// Connects an asset provider to the syncing system so pending uploads are uploaded.
class SyncingAssetProvider extends AssetProvider {
  final AssetProvider localAssetProvider;

  final AssetProvider sourceAssetProvider;

  SyncingAssetProvider({required this.localAssetProvider, required this.sourceAssetProvider});

  @override
  void onRegister(AppRegistration registration) {
    localAssetProvider.onRegister(registration);
    sourceAssetProvider.onRegister(registration);
  }

  @override
  Future<void> onReset(AppContext context) async {
    await localAssetProvider.onReset(context);
    await sourceAssetProvider.onReset(context);
  }

  @override
  DataSource<Asset> getDataSource(String id) {
    if (locate<SyncingModule>().isDisabled) {
      return sourceAssetProvider.getDataSource(id);
    }
    return _SyncingDataSource(
      assetId: id,
      localDataSource: localAssetProvider.getDataSource(id),
      sourceDataSource: sourceAssetProvider.getDataSource(id),
    );
  }

  @override
  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    if (locate<SyncingModule>().isDisabled) {
      return sourceAssetProvider.getMetadataDataSource(id);
    }
    return localAssetProvider.getMetadataDataSource(id);
  }
}

/// DataSource that enqueues publish actions to the syncing module.
class _SyncingDataSource extends DataSource<Asset> {
  final DataSource<Asset> localDataSource;
  final DataSource<Asset> sourceDataSource;
  final String assetId;

  var triedGet = false;

  late final SyncingModule syncingModule = locate<SyncingModule>();

  _SyncingDataSource({required this.localDataSource, required this.assetId, required this.sourceDataSource});

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
  Future<Asset?> getData() async {
    if (triedGet) {
      return await localDataSource.getData();
    }

    triedGet = true;
    final data = await localDataSource.getData();
    if (data == null) {
      final sourceData = await sourceDataSource.getData();
      if (sourceData != null) {
        await saveData(sourceData);
      }
      return sourceData;
    }
    return null;
  }
}
