import 'package:asset_core/asset_core.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final String Function(AssetPathContext pathContext) pathGetter;

  AdaptingAssetProvider({required this.context, required this.pathGetter});

  @override
  late final AssetProvider assetProvider = _getAssetProvider();

  AssetProvider _getAssetProvider() {
    if (context.context.environment == EnvironmentType.static.testing) {
      return AssetProvider.static.memory;
    } else if (context.context.environment == EnvironmentType.static.device) {
      return AssetProvider.static.file(context, pathGetter);
    } else if (context.context.environment.isOnline) {
      return AssetProvider.static.cloud(context, pathGetter);
    } else {
      return throw Exception('Invalid environment for adapting asset provider');
    }
  }
}
