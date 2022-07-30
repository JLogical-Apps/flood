import 'package:jlogical_utils/src/persistence/export.dart';
import 'package:jlogical_utils/src/pond/modules/asset/asset_metadata.dart';

import '../../../../persistence/export_core.dart';
import '../asset.dart';
import 'firebase_storage_asset_metadata_data_source.dart';

class FirebaseStorageAssetDataSource extends DataSource<Asset> {
  final String assetId;

  FirebaseStorageAssetDataSource({required this.assetId});

  late FirebaseStorageDataSource firebaseStorageDataSource = FirebaseStorageDataSource(storagePath: assetId);
  late FirebaseStorageAssetMetadataDataSource firebaseStorageAssetMetadataDataSource =
      FirebaseStorageAssetMetadataDataSource(assetId: assetId);

  @override
  Future<bool> exists() {
    return firebaseStorageDataSource.exists();
  }

  @override
  Future<Asset?> getData() async {
    final assetValue = await firebaseStorageDataSource.getData();
    if (assetValue == null) {
      return null;
    }

    final metadata =
        (await firebaseStorageAssetMetadataDataSource.getData()) ?? AssetMetadata.now(size: assetValue.length);

    return Asset(id: assetId, metadata: metadata, value: assetValue);
  }

  @override
  Future<void> saveData(Asset asset) async {
    await firebaseStorageDataSource.saveData(asset.value);
    await firebaseStorageAssetMetadataDataSource.saveData(asset.metadata ??
        AssetMetadata.now(
          size: asset.value.length,
        ));
  }

  @override
  Future<void> delete() async {
    await firebaseStorageDataSource.delete();
  }
}
