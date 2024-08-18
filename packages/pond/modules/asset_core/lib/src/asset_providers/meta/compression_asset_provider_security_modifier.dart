import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/compression_asset_provider.dart';
import 'package:asset_core/src/asset_providers/meta/asset_provider_meta_modifier.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';

class CompressionAssetProviderMetaModifier extends WrapperAssetProviderMetaModifier<CompressionAssetProvider> {
  @override
  String? getPath(CompressionAssetProvider assetProvider, AssetPathContext context) {
    final subAssetProvider = assetProvider.sourceAssetProvider;
    return AssetProviderMetaModifier.getModifierOrNull(subAssetProvider)?.getPath(subAssetProvider, context);
  }

  @override
  AssetSecurity? getSecurity(CompressionAssetProvider assetProvider) {
    final subAssetProvider = assetProvider.sourceAssetProvider;
    return AssetProviderMetaModifier.getModifierOrNull(subAssetProvider)?.getSecurity(subAssetProvider);
  }
}
