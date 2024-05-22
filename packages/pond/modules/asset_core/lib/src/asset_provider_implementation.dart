import 'package:asset_core/src/asset_providers/asset_provider.dart';

abstract class AssetProviderImplementation<T extends AssetProvider> {
  AssetProvider getImplementation(T prototype);

  Type get assetProviderType;
}

mixin IsAssetProviderImplementation<T extends AssetProvider> implements AssetProviderImplementation<T> {
  @override
  Type get assetProviderType => T;
}
