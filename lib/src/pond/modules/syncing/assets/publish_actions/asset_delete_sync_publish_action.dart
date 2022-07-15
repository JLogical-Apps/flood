import 'package:jlogical_utils/jlogical_utils.dart';

class AssetDeleteSyncPublishAction extends SyncPublishAction {
  late final assetIdProperty = FieldProperty<String>(name: 'asset').required();

  AssetDeleteSyncPublishAction();

  AssetDeleteSyncPublishAction.fromAssetId(String assetId) {
    assetIdProperty.value = assetId;
  }

  @override
  Future<void> publish() async {
    final assetProvider = locate<AssetModule>().assetProvider;
    if (assetProvider is! SyncingAssetProvider) {
      throw Exception('Cannot delete assets from an asset provider that isn\'t a SyncingAssetProvider!');
    }

    final assetId = assetIdProperty.value!;

    await assetProvider.sourceAssetProvider.getDataSource(assetId).delete();
  }
}
