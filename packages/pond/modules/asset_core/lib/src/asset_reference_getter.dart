import 'package:asset_core/src/asset_core_component.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';

class AssetReferenceGetter {
  final String id;
  final AssetProvider Function(AssetCoreComponent context) assetProviderGetter;

  AssetReferenceGetter({required this.id, required this.assetProviderGetter});
}
