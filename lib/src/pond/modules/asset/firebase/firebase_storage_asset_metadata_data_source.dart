import 'package:firebase_storage/firebase_storage.dart';
import 'package:jlogical_utils/src/pond/modules/asset/asset_metadata.dart';

import '../../../../persistence/export_core.dart';
import '../../../../utils/export_core.dart';

class FirebaseStorageAssetMetadataDataSource extends DataSource<AssetMetadata> {
  static const assetTimeCreatedField = 'assetTimeCreated';

  final String assetId;

  FirebaseStorageAssetMetadataDataSource({required this.assetId});

  Reference get storageReference => FirebaseStorage.instance.ref(assetId);

  @override
  Future<bool> exists() async {
    final downloadUrl = await guardAsync(() => storageReference.getDownloadURL());
    return downloadUrl != null;
  }

  @override
  Future<AssetMetadata?> getData() async {
    final fullMetadata = await guardAsync(() => storageReference.getMetadata());
    if (fullMetadata == null) {
      return null;
    }

    final timeCreated = fullMetadata.customMetadata?[assetTimeCreatedField]
        .mapIfNonNull((timeCreated) => int.tryParse(timeCreated))
        .mapIfNonNull((timeCreatedMillis) => DateTime.fromMillisecondsSinceEpoch(timeCreatedMillis));

    return AssetMetadata(
      timeCreated: timeCreated,
      lastUpdated: fullMetadata.updated,
      size: fullMetadata.size,
    );
  }

  @override
  Future<void> saveData(AssetMetadata data) async {
    final timeCreatedMillis = data.timeCreated?.millisecondsSinceEpoch;
    await storageReference.updateMetadata(SettableMetadata(
      customMetadata: {
        if (timeCreatedMillis != null) assetTimeCreatedField: timeCreatedMillis.toString(),
      },
    ));
  }

  @override
  Future<void> delete() {
    throw UnimplementedError('Cannot delete metadata from Firebase!');
  }
}
