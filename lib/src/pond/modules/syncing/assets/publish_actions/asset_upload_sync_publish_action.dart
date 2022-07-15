import 'package:jlogical_utils/jlogical_utils.dart';

class AssetUploadSyncPublishAction extends SyncPublishAction {
  late final assetIdProperty = FieldProperty<String>(name: 'asset').required();

  AssetUploadSyncPublishAction();

  AssetUploadSyncPublishAction.fromAssetId(String assetId) {
    assetIdProperty.value = assetId;
  }

  @override
  Future<void> publish() async {
    final assetProvider = locate<AssetModule>().assetProvider;
    if (assetProvider is! SyncingAssetProvider) {
      throw Exception('Cannot upload assets from an asset provider that isn\'t a SyncingAssetProvider!');
    }

    final assetId = assetIdProperty.value!;

    final localDataSource = assetProvider.localAssetProvider.getDataSource(assetId);
    if (!await localDataSource.exists()) {
      return;
    }

    final asset = await localDataSource.getData();
    if (asset == null) {
      return;
    }

    await assetProvider.sourceAssetProvider.getDataSource(assetId).saveData(asset);
  }
}
