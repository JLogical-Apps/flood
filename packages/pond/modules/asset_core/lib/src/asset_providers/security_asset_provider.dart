import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:model_core/model_core.dart';

class SecurityAssetProvider with IsAssetProviderWrapper {
  @override
  final AssetProvider assetProvider;

  final AssetSecurity assetSecurity;

  SecurityAssetProvider({required this.assetProvider, required this.assetSecurity});

  @override
  AssetReference getById(AssetPathContext context, String id) {
    final sourceAssetReference = assetProvider.getById(context, id);
    return AssetReference(
      id: id,
      assetMetadataModel: sourceAssetReference.assetMetadataModel.asyncMap((metadata) async {
        if (!await assetSecurity.read.passes(context)) {
          throw Exception('Invalid permission to read asset with id [$id]');
        }

        return metadata;
      }),
      assetModel: sourceAssetReference.assetModel.asyncMap((asset) async {
        if (!await assetSecurity.read.passes(context)) {
          throw Exception('Invalid permission to read asset with id [$id]');
        }

        return asset;
      }),
    );
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    if (!await assetSecurity.write.passes(context) || !await assetSecurity.write.passesWrite(context, asset: asset)) {
      throw Exception('Invalid permission to upload asset with id [${asset.id}]');
    }

    return await assetProvider.upload(context, asset);
  }

  @override
  Future onDelete(AssetPathContext context, String id) async {
    if (!await assetSecurity.delete.passes(context)) {
      throw Exception('Invalid permission to delete asset with id [$id]');
    }

    await assetProvider.delete(context, id);
  }
}
