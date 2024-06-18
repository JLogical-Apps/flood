import 'package:asset_core/src/asset_providers/meta/asset_provider_meta_modifier.dart';
import 'package:asset_core/src/asset_providers/security/asset_security.dart';
import 'package:asset_core/src/asset_providers/security_asset_provider.dart';

class SecurityRepositoryMetaModifier extends WrapperAssetProviderMetaModifier<SecurityAssetProvider> {
  @override
  AssetSecurity getSecurity(SecurityAssetProvider assetProvider) {
    return assetProvider.assetSecurity;
  }
}
