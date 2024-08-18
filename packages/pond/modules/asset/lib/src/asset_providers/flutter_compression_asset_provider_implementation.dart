import 'package:asset/asset.dart';
import 'package:asset/src/asset_providers/flutter_compression_asset_provider.dart';

class FlutterCompressionAssetProviderImplementation with IsAssetProviderImplementation<CompressionAssetProvider> {
  @override
  AssetProvider getImplementation(CompressionAssetProvider prototype) {
    return FlutterCompressionAssetProvider(assetProvider: prototype.sourceAssetProvider);
  }
}
