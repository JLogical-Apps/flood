import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/cloud_asset_provider.dart';
import 'package:asset_core/src/asset_providers/meta/asset_provider_meta_modifier.dart';

class CloudAssetProviderMetaModifier extends WrapperAssetProviderMetaModifier<CloudAssetProvider> {
  @override
  String? getPath(CloudAssetProvider assetProvider, AssetPathContext context) {
    return assetProvider.pathGetter(context);
  }
}
