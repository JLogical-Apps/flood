import 'package:asset_core/asset_core.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';

abstract class AssetProvider {
  AssetReference getById(String id);

  static final AssetProviderStatic static = AssetProviderStatic();
}

class AssetProviderStatic {
  MemoryAssetProvider get memory => MemoryAssetProvider();
}

mixin IsAssetProvider implements AssetProvider {}

abstract class AssetProviderWrapper implements AssetProvider {
  AssetProvider get assetProvider;
}

mixin IsAssetProviderWrapper implements AssetProviderWrapper {
  @override
  AssetReference getById(String id) {
    return assetProvider.getById(id);
  }
}
