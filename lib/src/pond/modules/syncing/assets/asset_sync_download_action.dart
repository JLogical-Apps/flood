import 'package:jlogical_utils/jlogical_utils.dart';

class AssetSyncDownloadAction extends SyncDownloadAction {
  final Future<List<String>> Function() downloadAssetIdsGetter;

  AssetSyncDownloadAction({required this.downloadAssetIdsGetter});

  @override
  Future<void> download() async {
    final assetIds = await downloadAssetIdsGetter();

    final assetProvider = locate<AssetModule>().assetProvider;
    if (assetProvider is! SyncingAssetProvider) {
      throw Exception('Cannot download assets from an asset provider that isn\'t a SyncingAssetProvider!');
    }

    for (final assetId in assetIds) {
      final sourceDataSource = assetProvider.sourceAssetProvider.getDataSource(assetId);
      if (!await sourceDataSource.exists()) {
        continue;
      }

      final asset = await sourceDataSource.getData();
      if (asset == null) {
        continue;
      }

      await assetProvider.localAssetProvider.getDataSource(assetId).saveData(asset);
    }
  }
}
