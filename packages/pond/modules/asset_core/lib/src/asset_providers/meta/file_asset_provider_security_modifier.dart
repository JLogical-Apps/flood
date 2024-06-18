import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/file_asset_provider.dart';
import 'package:asset_core/src/asset_providers/meta/asset_provider_meta_modifier.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';

class FileAssetProviderMetaModifier extends AssetProviderMetaModifier<FileAssetProvider> {
  @override
  String? getPath(FileAssetProvider assetProvider, AssetPathContext context) {
    return assetProvider.pathGetter(context);
  }

  @override
  AssetSecurity? getSecurity(FileAssetProvider assetProvider) {
    return null;
  }
}
