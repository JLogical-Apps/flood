import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_metadata.dart';
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
