import 'package:jlogical_utils/jlogical_utils.dart';

class AssetSyncDownloadAction extends SyncDownloadAction {
  final Future<List<String>> Function() downloadAssetIdsGetter;

  late SyncingAssetProvider assetProvider = locate<AssetModule>().assetProvider.as<SyncingAssetProvider>() ??
      (throw Exception('Cannot download assets from an asset provider that isn\'t a SyncingAssetProvider!'));

  AssetSyncDownloadAction({required this.downloadAssetIdsGetter});

  @override
  Future<void> download() async {
    final assetIds = await downloadAssetIdsGetter();
    for (final assetId in assetIds) {
      await _downloadAssetIfFound(assetId);
    }
  }

  Future<void> _downloadAssetIfFound(String assetId) async {
    if (await _localHasSameOrNewerVersion(assetId)) {
      return;
    }

    final sourceDataSource = assetProvider.sourceAssetProvider.getDataSource(assetId);
    if (!await sourceDataSource.exists()) {
      return;
    }

    final asset = await sourceDataSource.getData();
    if (asset == null) {
      return;
    }

    await assetProvider.localAssetProvider.getDataSource(assetId).saveData(asset);
    locate<AssetModule>().saveAssetToCache(asset);
  }

  Future<bool> _localHasSameOrNewerVersion(String assetId) async {
    final sourceMetadataDataSource = assetProvider.sourceAssetProvider.getMetadataDataSource(assetId);
    if (!await sourceMetadataDataSource.exists()) {
      return false;
    }

    final localMetadataDataSource = assetProvider.localAssetProvider.getMetadataDataSource(assetId);
    if (!await localMetadataDataSource.exists()) {
      return false;
    }

    final sourceMetadata = await sourceMetadataDataSource.getData();
    final localMetadata = await localMetadataDataSource.getData();

    if (sourceMetadata == null || localMetadata == null) {
      return false;
    }

    if (sourceMetadata.lastUpdated == null || localMetadata.lastUpdated == null) {
      return false;
    }

    return localMetadata.lastUpdated!.millisecondsSinceEpoch >= sourceMetadata.lastUpdated!.millisecondsSinceEpoch;
  }
}
