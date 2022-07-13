import '../sync_download_action.dart';

class AssetSyncDownloadAction extends SyncDownloadAction {
  final Future<List<String>> Function() downloadAssetIdsGetter;

  AssetSyncDownloadAction({required this.downloadAssetIdsGetter});

  @override
  Future<void> download() async {
    final assetIds = await downloadAssetIdsGetter();

    // TODO
  }
}
