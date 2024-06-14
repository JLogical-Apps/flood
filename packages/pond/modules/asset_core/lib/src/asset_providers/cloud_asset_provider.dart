import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_providers/blank_asset_provider.dart';

class CloudAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final String Function(AssetPathContext pathContext) pathGetter;

  CloudAssetProvider({required this.context, required this.pathGetter});

  @override
  late final AssetProvider assetProvider = context.getImplementationOrNull(this) ?? BlankAssetProvider();
}
