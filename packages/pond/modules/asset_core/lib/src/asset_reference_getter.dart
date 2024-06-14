import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';

class AssetReferenceGetter {
  final String assetId;
  final AssetPathContext Function() pathContextGetter;
  final AssetProvider Function(AssetCoreComponent context) assetProviderGetter;

  AssetReferenceGetter({
    required this.assetId,
    required this.pathContextGetter,
    required this.assetProviderGetter,
  });

  AssetPathContext get pathContext => pathContextGetter();
}
