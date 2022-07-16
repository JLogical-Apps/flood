import 'package:jlogical_utils/jlogical_utils.dart';

class AssetDeleteSyncPublishAction extends SyncPublishAction {
  late final assetIdProperty = FieldProperty<String>(name: 'asset').required();

  AssetDeleteSyncPublishAction();

  AssetDeleteSyncPublishAction.fromAssetId(String assetId) {
    assetIdProperty.value = assetId;
  }

  @override
  List<Property> get properties => super.properties + [assetIdProperty];

  @override
  Future<void> publish() async {
    final assetProvider = locate<AssetModule>().assetProvider;
    if (assetProvider is! SyncingAssetProvider) {
      throw Exception('Cannot delete assets from an asset provider that isn\'t a SyncingAssetProvider!');
    }

    final assetId = assetIdProperty.value!;

    final dataSource = assetProvider.sourceAssetProvider.getDataSource(assetId);
    if (!await dataSource.exists()) {
      return;
    }

    await dataSource.delete();
  }
}
