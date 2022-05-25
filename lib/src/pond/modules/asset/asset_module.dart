import 'package:collection/collection.dart';

import '../../context/module/app_module.dart';
import 'asset.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final List<AssetProvider> assetProviders = [];

  AssetModule withAssetProvider(AssetProvider assetProvider) {
    assetProviders.add(assetProvider);
    return this;
  }

  AssetProvider? getAssetProviderOrNullRuntime(Type assetType) {
    return assetProviders.firstWhereOrNull((provider) => provider.assetType == assetType);
  }

  AssetProvider getAssetProviderRuntime(Type assetType) {
    return getAssetProviderOrNullRuntime(assetType) ??
        (throw Exception('Could not find AssetProvider that handles [$assetType]'));
  }

  AssetProvider<A, T>? getAssetProviderOrNull<A extends Asset<T>, T>() {
    return getAssetProviderOrNullRuntime(A) as AssetProvider<A, T>?;
  }

  AssetProvider<A, T> getAssetProvider<A extends Asset<T>, T>() {
    return getAssetProviderRuntime(A) as AssetProvider<A, T>;
  }
}
