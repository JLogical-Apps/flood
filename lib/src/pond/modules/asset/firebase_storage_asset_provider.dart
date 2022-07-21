import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export.dart';
import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_metadata.dart';
import 'asset_provider.dart';

class FirebaseStorageAssetProvider extends AssetProvider {
  final Directory cacheDirectory;

  FirebaseStorageAssetProvider({Directory? cacheDirectory})
      : this.cacheDirectory = cacheDirectory ?? AppContext.global.cacheDirectory / 'assets';

  @override
  DataSource<Asset> getDataSource(String id) {
    return FirebaseStorageDataSource(storagePath: id).withCache(RawFileDataSource(file: _getCacheFile(id))).map(
      onLoad: (bytes) async {
        final metadata = await getMetadataDataSource(id).getData();
        return bytes.mapIfNonNull((bytes) => Asset(
              id: id,
              value: bytes,
              metadata: metadata!,
            ));
      },
      onSave: (asset) {
        return asset.value;
      },
    );
  }

  @override
  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    return CustomDataSource(
      onGet: () async {
        final reference = FirebaseStorage.instance.ref(id);
        final metadata = await guardAsync(() => reference.getMetadata());
        if (metadata == null) {
          return null;
        }
        return AssetMetadata(lastUpdated: metadata.updated);
      },
      onSave: (metadata) => throw UnimplementedError(),
      onDelete: () => throw UnimplementedError(),
    );
  }

  File _getCacheFile(String id) {
    return cacheDirectory - id;
  }
}
