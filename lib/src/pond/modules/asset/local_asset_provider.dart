import '../../../persistence/export_core.dart';
import 'asset.dart';
import 'asset_metadata.dart';
import 'asset_provider.dart';

class LocalAssetProvider extends AssetProvider {
  final Map<String, Asset> _assetById = {};

  @override
  DataSource<Asset> getDataSource(String id) {
    return CustomDataSource(
      onGet: () => _assetById[id],
      onSave: (asset) => _assetById[id] = asset.copyWith(id: id),
      onDelete: () => _assetById.remove(id),
    );
  }

  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    return CustomDataSource(
      onGet: () => _assetById[id]?.metadata,
      onSave: (_) => throw UnimplementedError(),
      onDelete: () => throw UnimplementedError(),
    );
  }
}
