import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';

abstract class AssetProvider {
  AssetReference getById(String id);

  Future<Asset> upload(Asset assetUpload);

  Future<void> delete(String id);

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
