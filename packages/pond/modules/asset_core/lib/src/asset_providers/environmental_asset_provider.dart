import 'package:asset_core/asset_core.dart';

class EnvironmentalAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final AssetProvider Function(AssetCoreComponent context) assetProviderGetter;

  EnvironmentalAssetProvider({
    required this.context,
    required this.assetProviderGetter,
  });

  @override
  late final AssetProvider assetProvider = assetProviderGetter(context);
}
