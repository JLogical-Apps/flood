import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';

abstract class AssetProvider {
  AssetReference getById(String id);

  Future<List<AssetReference>> listReferences();

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
  AssetReference getById(String id) => assetProvider.getById(id);

  @override
  Future<List<AssetReference>> listReferences() => assetProvider.listReferences();

  @override
  Future<Asset> upload(Asset assetUpload) => assetProvider.upload(assetUpload);

  @override
  Future<void> delete(String id) => assetProvider.delete(id);
}
