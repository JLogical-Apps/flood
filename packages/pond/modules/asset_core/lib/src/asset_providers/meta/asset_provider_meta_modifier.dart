import 'package:asset_core/asset_core.dart';
import 'package:asset_core/src/asset_providers/meta/cloud_asset_provider_security_modifier.dart';
import 'package:asset_core/src/asset_providers/meta/file_asset_provider_security_modifier.dart';
import 'package:asset_core/src/asset_providers/meta/security_asset_provider_security_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class AssetProviderMetaModifier<A extends AssetProvider> with IsTypedModifier<A, AssetProvider> {
  String? getPath(A assetProvider, AssetPathContext context);

  AssetSecurity? getSecurity(A assetProvider);

  static final assetProviderMetaModifierResolver =
      ModifierResolver<AssetProviderMetaModifier, AssetProvider>(modifiers: [
    SecurityRepositoryMetaModifier(),
    CloudAssetProviderMetaModifier(),
    FileAssetProviderMetaModifier(),
    WrapperAssetProviderMetaModifier(),
  ]);

  static AssetProviderMetaModifier? getModifierOrNull(AssetProvider assetProvider) {
    return assetProviderMetaModifierResolver.resolveOrNull(assetProvider);
  }

  static AssetProviderMetaModifier getModifier(AssetProvider assetProvider) {
    return getModifierOrNull(assetProvider) ??
        (throw Exception('Could not find meta modifier for asset provider [$assetProvider]!'));
  }
}

class WrapperAssetProviderMetaModifier<A extends AssetProviderWrapper> extends AssetProviderMetaModifier<A> {
  @override
  String? getPath(A assetProvider, AssetPathContext context) {
    final subAssetProvider = assetProvider.assetProvider;
    return AssetProviderMetaModifier.getModifierOrNull(subAssetProvider)?.getPath(subAssetProvider, context);
  }

  @override
  AssetSecurity? getSecurity(A assetProvider) {
    final subAssetProvider = assetProvider.assetProvider;
    return AssetProviderMetaModifier.getModifierOrNull(subAssetProvider)?.getSecurity(subAssetProvider);
  }
}
