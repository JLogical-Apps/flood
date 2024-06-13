import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';

class BlankAssetProvider with IsAssetProvider {
  @override
  AssetReference getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> onDelete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Asset> onUpload(Asset asset) {
    throw UnimplementedError();
  }
}
