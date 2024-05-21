import 'dart:async';

import 'package:asset_core/asset_core.dart';
import 'package:asset_core/src/asset_providers/adapting_asset_provider.dart';
import 'package:asset_core/src/asset_providers/cache_asset_provider.dart';
import 'package:asset_core/src/asset_providers/file_asset_provider.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';

abstract class AssetProvider {
  AssetReference getById(String id);

  Future<List<String>> onListIds();

  Future<Asset> onUpload(Asset asset);

  Future<void> onDelete(String id);

  Future<void> onReset();

  static final AssetProviderStatic static = AssetProviderStatic();
}

class AssetProviderStatic {
  MemoryAssetProvider get memory => MemoryAssetProvider();

  FileAssetProvider file(AssetCoreComponent context, String path) => FileAssetProvider(context: context, path: path);

  AdaptingAssetProvider adapting(AssetCoreComponent context, String path) =>
      AdaptingAssetProvider(context: context, path: path);
}

mixin IsAssetProvider implements AssetProvider {
  @override
  Future<void> onReset() async {}
}

extension AssetProviderExtensions on AssetProvider {
  Future<List<AssetReference>> listAssetReferences() async {
    final ids = await onListIds();
    return ids.map((id) => getById(id)).toList();
  }

  Future<Asset> upload(Asset assetUpload) => onUpload(assetUpload);

  Future<void> delete(String id) => onDelete(id);

  Future<void> reset() => onReset();

  AssetProvider withCache() {
    return CacheAssetProvider(assetProvider: this);
  }

  AssetReferenceGetter getterById(String id) {
    return AssetReferenceGetter(id: id, assetProviderGetter: (_) => this);
  }
}

abstract class AssetProviderWrapper implements AssetProvider {
  AssetProvider get assetProvider;
}

mixin IsAssetProviderWrapper implements AssetProviderWrapper {
  @override
  AssetReference getById(String id) => assetProvider.getById(id);

  @override
  Future<List<String>> onListIds() => assetProvider.onListIds();

  @override
  Future<Asset> onUpload(Asset asset) => assetProvider.onUpload(asset);

  @override
  Future<void> onDelete(String id) => assetProvider.onDelete(id);

  @override
  Future<void> onReset() => assetProvider.onReset();
}
