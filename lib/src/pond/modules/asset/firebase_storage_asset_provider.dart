import 'dart:io';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export.dart';
import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_provider.dart';

class FirebaseStorageAssetProvider extends AssetProvider {
  final Directory cacheDirectory;

  FirebaseStorageAssetProvider({Directory? cacheDirectory})
      : this.cacheDirectory = cacheDirectory ?? AppContext.global.cacheDirectory / 'assets';

  @override
  DataSource<Asset> getDataSource(String id) {
    return FirebaseStorageDataSource(storagePath: id).withCache(RawFileDataSource(file: _getCacheFile(id))).map(
      onLoad: (bytes) {
        return bytes.mapIfNonNull((bytes) => Asset(id: id, name: id, value: bytes));
      },
      onSave: (asset) {
        return asset.value;
      },
    );
  }

  File _getCacheFile(String id) {
    return cacheDirectory - id;
  }
}
