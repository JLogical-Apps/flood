import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../persistence/export_core.dart';
import '../asset.dart';
import '../asset_metadata.dart';
import '../asset_provider.dart';
import '../file/file_asset_data_source.dart';
import 'firebase_storage_asset_data_source.dart';
import 'firebase_storage_asset_metadata_data_source.dart';

class FirebaseStorageAssetProvider extends AssetProvider {
  static const assetTimeCreatedField = 'assetTimeCreated';

  FirebaseStorageAssetProvider({Directory? cacheDirectory});

  @override
  DataSource<Asset> getDataSource(String id) {
    return FirebaseStorageAssetDataSource(assetId: id).withCache(kIsWeb ? LocalDataSource() : FileAssetDataSource(assetId: id));
  }

  @override
  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    return FirebaseStorageAssetMetadataDataSource(assetId: id);
  }
}
