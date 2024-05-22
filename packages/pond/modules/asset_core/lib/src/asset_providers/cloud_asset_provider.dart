import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_providers/blank_asset_provider.dart';

class CloudAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final String path;

  CloudAssetProvider({required this.context, required this.path});

  @override
  late final AssetProvider assetProvider = context.getImplementationOrNull(this) ?? BlankAssetProvider();
}
