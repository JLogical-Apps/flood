import 'package:asset/asset.dart';
import 'package:firebase/src/storage/firebase_storage_asset_provider.dart';

class FirebaseStorageAssetProviderImplementation with IsAssetProviderImplementation<CloudAssetProvider> {
  @override
  AssetProvider getImplementation(CloudAssetProvider prototype) {
    return FirebaseStorageAssetProvider(
      corePondContext: prototype.context.context,
      pathGetter: prototype.pathGetter,
    );
  }
}
