import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/adapting_asset_provider.dart';
import 'package:asset_core/src/asset_providers/cache_asset_provider.dart';
import 'package:asset_core/src/asset_providers/cloud_asset_provider.dart';
import 'package:asset_core/src/asset_providers/file_asset_provider.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';
import 'package:asset_core/src/asset_providers/security_asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:asset_core/src/asset_reference_getter.dart';
import 'package:drop_core/drop_core.dart';

abstract class AssetProvider {
  AssetReference getById(AssetPathContext context, String id);

  Future<Asset> onUpload(AssetPathContext context, Asset asset);

  Future<void> onDelete(AssetPathContext context, String id);

  Future<void> onReset();

  static final AssetProviderStatic static = AssetProviderStatic();
}

class AssetProviderStatic {
  MemoryAssetProvider get memory => MemoryAssetProvider();

  FileAssetProvider file(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) =>
      FileAssetProvider(context: context, pathGetter: pathGetter);

  CloudAssetProvider cloud(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) =>
      CloudAssetProvider(context: context, pathGetter: pathGetter);

  AdaptingAssetProvider adapting(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) =>
      AdaptingAssetProvider(context: context, pathGetter: pathGetter);
}

mixin IsAssetProvider implements AssetProvider {
  @override
  Future<void> onReset() async {}
}

extension AssetProviderExtensions on AssetProvider {
  Future<Asset> upload(AssetPathContext context, Asset assetUpload) => onUpload(context, assetUpload);

  Future<void> delete(AssetPathContext context, String id) => onDelete(context, id);

  Future<void> reset() => onReset();

  AssetProvider withCache() {
    return CacheAssetProvider(assetProvider: this);
  }

  AssetProvider withSecurity(AssetSecurity assetSecurity) {
    return SecurityAssetProvider(assetProvider: this, assetSecurity: assetSecurity);
  }

  AssetProvider fromRepository<E extends Entity>(AssetCoreComponent context) {
    final entityRepository = context.context.dropCoreComponent.getRepositoryFor<E>();
    return SecurityAssetProvider(assetProvider: this, assetSecurity: AssetSecurity.fromRepository(entityRepository));
  }

  AssetReferenceGetter getterById(AssetPathContext context, String id) {
    return AssetReferenceGetter(
      assetId: id,
      pathContextGetter: (_) => context,
      assetProviderGetter: (_) => this,
    );
  }
}

abstract class AssetProviderWrapper implements AssetProvider {
  AssetProvider get assetProvider;
}

mixin IsAssetProviderWrapper implements AssetProviderWrapper {
  @override
  AssetReference getById(AssetPathContext context, String id) => assetProvider.getById(context, id);

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) => assetProvider.onUpload(context, asset);

  @override
  Future<void> onDelete(AssetPathContext context, String id) => assetProvider.onDelete(context, id);

  @override
  Future<void> onReset() => assetProvider.onReset();
}
