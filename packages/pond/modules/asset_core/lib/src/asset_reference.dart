import 'dart:typed_data';

import 'package:asset_core/asset_core.dart';
import 'package:persistence_core/persistence_core.dart';

abstract class AssetReference {
  DataSource<AssetMetadata> get assetMetadataDataSource;

  DataSource<Uint8List> get bytesDataSource;

  factory AssetReference({
    required DataSource<AssetMetadata> assetMetadataDataSource,
    required DataSource<Uint8List> bytesDataSource,
  }) =>
      _AssetReferenceImpl(
        assetMetadataDataSource: assetMetadataDataSource,
        bytesDataSource: bytesDataSource,
      );
}

mixin IsAssetReference implements AssetReference {}

class _AssetReferenceImpl with IsAssetReference {
  @override
  final DataSource<AssetMetadata> assetMetadataDataSource;

  @override
  final DataSource<Uint8List> bytesDataSource;

  _AssetReferenceImpl({required this.assetMetadataDataSource, required this.bytesDataSource});
}
