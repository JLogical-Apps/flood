import 'package:jlogical_utils/src/pond/modules/syncing/assets/syncing_asset_provider.dart';

import '../../asset/asset_provider.dart';

extension SyncingAssetProviderExtensions on AssetProvider {
  SyncingAssetProvider asSyncingAssetProvider(AssetProvider localAssetProvider) {
    return SyncingAssetProvider(
      sourceAssetProvider: this,
      localAssetProvider: localAssetProvider,
    );
  }
}
