import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/cache_asset_provider.dart';
import 'package:asset_core/src/asset_providers/cloud_asset_provider.dart';
import 'package:asset_core/src/asset_providers/environmental_asset_provider.dart';
import 'package:asset_core/src/asset_providers/file_asset_provider.dart';
import 'package:asset_core/src/asset_providers/memory_asset_provider.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';
import 'package:asset_core/src/asset_providers/security_asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:asset_core/src/asset_reference_getter.dart';
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';

abstract class AssetProvider {
  AssetReference getById(AssetPathContext context, String id);

  Future<Asset> onUpload(AssetPathContext context, Asset asset);

  Future<void> onDelete(AssetPathContext context, String id);

  Future<void> onReset();

  static final AssetProviderStatic static = AssetProviderStatic();
}

class AssetProviderStatic {
  MemoryAssetProvider get memory => MemoryAssetProvider();

  FileAssetProvider file(
    AssetCoreComponent context,
    String Function(AssetPathContext context) pathGetter, {
    bool isTemporary = false,
  }) =>
      FileAssetProvider(context: context, pathGetter: pathGetter, isTemporary: isTemporary);

  CloudAssetProvider cloud(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) =>
      CloudAssetProvider(context: context, pathGetter: pathGetter);

  AssetProvider environmental(
    AssetCoreComponent context,
    AssetProvider Function(AssetCoreComponent context) assetProviderGetter,
  ) =>
      EnvironmentalAssetProvider(
        context: context,
        assetProviderGetter: assetProviderGetter,
      );

  AssetProvider adapting(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) =>
      environmental(
        context,
        (context) {
          if (context.context.environment == EnvironmentType.static.testing) {
            return AssetProvider.static.memory;
          } else if (context.context.environment == EnvironmentType.static.device) {
            return AssetProvider.static.file(context, pathGetter).withCache();
          } else if (context.context.environment.isOnline) {
            if (context.context.environmentCoreComponent.platform == Platform.web) {
              return AssetProvider.static.cloud(context, pathGetter);
            }

            return AssetProvider.static.cloud(context, pathGetter).withCache(AssetProvider.static.file(
                  context,
                  (context) => 'assetCache/${pathGetter(context)}',
                  isTemporary: true,
                ));
          } else {
            return throw Exception('Invalid environment for environmental asset provider');
          }
        },
      );

  AssetProvider adaptingToDevice(AssetCoreComponent context, String Function(AssetPathContext context) pathGetter) {
    return environmental(
      context,
      (context) {
        if (context.context.environment == EnvironmentType.static.testing || context.context.platform == Platform.web) {
          return AssetProvider.static.memory;
        } else {
          return AssetProvider.static.file(context, pathGetter).withCache();
        }
      },
    );
  }
}

mixin IsAssetProvider implements AssetProvider {
  @override
  Future<void> onReset() async {}
}

extension AssetProviderExtensions on AssetProvider {
  Future<Asset> upload(AssetPathContext context, Asset assetUpload) => onUpload(context, assetUpload);

  Future<void> delete(AssetPathContext context, String id) => onDelete(context, id);

  Future<void> reset() => onReset();

  AssetProvider withCache([AssetProvider? cacheAssetProvider]) {
    return CacheAssetProvider(
      sourceAssetProvider: this,
      cacheAssetProvider: cacheAssetProvider ?? AssetProvider.static.memory,
    );
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
