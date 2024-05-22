import 'dart:io';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_metadata.dart';
import 'package:asset_core/src/asset_references/file_asset_reference.dart';
import 'package:model_core/model_core.dart';

abstract class AssetReference {
  String get id;

  Model<AssetMetadata> get assetMetadataModel;

  Model<Asset> get assetModel;

  factory AssetReference({
    required String id,
    Model<AssetMetadata>? assetMetadataModel,
    required Model<Asset> assetModel,
  }) =>
      _AssetReferenceImpl(
        id: id,
        assetMetadataModel: assetMetadataModel ?? assetModel.map((asset) => asset.metadata),
        assetModel: assetModel,
      );
}

mixin IsAssetReference implements AssetReference {}

extension AssetReferenceExtensions on AssetReference {
  FileAssetReference withFile(File file) {
    return FileAssetReference(assetReference: this, file: file);
  }
}

class _AssetReferenceImpl with IsAssetReference {
  @override
  final String id;

  @override
  final Model<AssetMetadata> assetMetadataModel;

  @override
  final Model<Asset> assetModel;

  _AssetReferenceImpl({
    required this.id,
    required this.assetMetadataModel,
    required this.assetModel,
  });
}

abstract class AssetReferenceWrapper implements AssetReference {
  AssetReference get assetReference;
}

mixin IsAssetReferenceWrapper implements AssetReferenceWrapper {
  @override
  String get id => assetReference.id;

  @override
  Model<AssetMetadata> get assetMetadataModel => assetReference.assetMetadataModel;

  @override
  Model<Asset> get assetModel => assetReference.assetModel;
}
