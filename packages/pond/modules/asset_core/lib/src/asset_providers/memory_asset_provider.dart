import 'dart:typed_data';

import 'package:asset_core/src/asset_metadata.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:persistence_core/persistence_core.dart';

class MemoryAssetProvider with IsAssetProvider {
  final Map<String, DataSource<AssetMetadata>> _assetMetadataDataSourceById = {};
  final Map<String, DataSource<Uint8List>> _assetBytesDataSourceById = {};

  @override
  AssetReference getById(String id) {
    return AssetReference(
      assetMetadataDataSource: _assetMetadataDataSourceById.putIfAbsent(id, () => DataSource.static.memory()),
      bytesDataSource: _assetBytesDataSourceById.putIfAbsent(id, () => DataSource.static.memory()),
    );
  }
}
