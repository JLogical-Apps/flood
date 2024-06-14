import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';

class BlankAssetProvider with IsAssetProvider {
  @override
  AssetReference getById(AssetPathContext context, String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) {
    throw UnimplementedError();
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) {
    throw UnimplementedError();
  }
}
