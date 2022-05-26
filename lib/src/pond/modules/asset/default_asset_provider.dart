import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';

import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import '../../export_core.dart';
import 'asset.dart';
import 'asset_provider.dart';
import 'file_asset_provider.dart';
import 'firebase_storage_asset_provider.dart';
import 'local_asset_provider.dart';

class DefaultAssetProvider extends AssetProvider {
  late AssetProvider assetProvider = _getAssetProvider();

  @override
  DataSource<Asset> getDataSource(String id) {
    return assetProvider.getDataSource(id);
  }

  AssetProvider _getAssetProvider() {
    final environment = AppContext.global.environment;

    switch (environment) {
      case Environment.testing:
        return LocalAssetProvider();
      case Environment.device:
        return FileAssetProvider();
      default:
        return FirebaseStorageAssetProvider();
    }
  }
}
