import 'package:jlogical_utils/jlogical_utils.dart';

class AdaptingAssetProvider extends DefaultAssetProvider {
  @override
  AssetProvider getOnlineAssetProvider() {
    return super.getOnlineAssetProvider().asSyncingAssetProvider(getFileAssetProvider());
  }
}
