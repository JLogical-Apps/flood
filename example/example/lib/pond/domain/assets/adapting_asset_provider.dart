import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class AdaptingAssetProvider extends DefaultAssetProvider {
  @override
  AssetProvider getOnlineAssetProvider() {
    return super.getOnlineAssetProvider().asSyncingAssetProvider(kIsWeb ? getLocalAssetProvider() : getFileAssetProvider());
  }
}
