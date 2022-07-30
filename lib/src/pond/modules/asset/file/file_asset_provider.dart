import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/asset/metadata_record/asset_metadata_record_repository.dart';
import '../asset_metadata.dart';
import 'file_asset_data_source.dart';
import 'file_asset_metadata_data_source.dart';

class FileAssetProvider extends AssetProvider {
  @override
  void onRegister(AppRegistration registration) {
    registration.register(AssetMetadataRecordRepository());
  }

  @override
  Future<void> onReset(AppContext context) async {
    final assetDirectory = FileAssetDataSource.baseDirectory;
    if (await assetDirectory.exists()) {
      await assetDirectory.delete(recursive: true);
    }
  }

  @override
  DataSource<Asset> getDataSource(String id) {
    return FileAssetDataSource(assetId: id);
  }

  @override
  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    return FileAssetMetadataDataSource(assetId: id);
  }
}
