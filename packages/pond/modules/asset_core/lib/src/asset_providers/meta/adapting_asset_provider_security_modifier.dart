import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/adapting_asset_provider.dart';
import 'package:asset_core/src/asset_providers/meta/asset_provider_meta_modifier.dart';

class AdaptingAssetProviderMetaModifier extends WrapperAssetProviderMetaModifier<AdaptingAssetProvider> {
  @override
  String? getPath(AdaptingAssetProvider assetProvider, AssetPathContext context) {
    return assetProvider.pathGetter(context);
  }
}
