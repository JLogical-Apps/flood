import '../../../persistence/export_core.dart';
import 'asset.dart';
import 'asset_provider.dart';

class LocalAssetProvider extends AssetProvider {
  @override
  DataSource<Asset> getDataSource(String id) {
    return LocalDataSource();
  }
}
