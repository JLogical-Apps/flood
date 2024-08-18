import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_providers/blank_asset_provider.dart';

class CompressionAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final AssetProvider sourceAssetProvider;

  CompressionAssetProvider({required this.context, required this.sourceAssetProvider});

  @override
  late final AssetProvider assetProvider = context.getImplementationOrNull(this) ?? BlankAssetProvider();
}
