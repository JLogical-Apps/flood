import 'package:asset_core/asset_core.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final String path;

  AdaptingAssetProvider({required this.context, required this.path});

  @override
  late final AssetProvider assetProvider = _getAssetProvider();

  AssetProvider _getAssetProvider() {
    if (context.context.environment == EnvironmentType.static.testing) {
      return AssetProvider.static.memory;
    } else if (context.context.environment == EnvironmentType.static.device) {
      return AssetProvider.static.file(context, path).withCache();
    } else {
      return throw Exception('Invalid environment for adapting asset provider');
    }
  }
}
