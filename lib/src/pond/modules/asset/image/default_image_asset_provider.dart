import 'dart:typed_data';

import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';

import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import '../../../export_core.dart';
import 'file_image_asset_provider.dart';
import 'firebase_storage_image_asset_provider.dart';
import 'image_asset_provider.dart';
import 'local_image_asset_provider.dart';

class DefaultImageAssetProvider extends ImageAssetProvider {
  late ImageAssetProvider imageAssetProvider = _getImageAssetProvider();

  @override
  DataSource<Uint8List> getDataSource(String id) {
    return imageAssetProvider.getDataSource(id);
  }

  ImageAssetProvider _getImageAssetProvider() {
    final environment = AppContext.global.environment;

    switch (environment) {
      case Environment.testing:
        return LocalImageAssetProvider();
      case Environment.device:
        return FileImageAssetProvider();
      default:
        return FirebaseStorageImageAssetProvider();
    }
  }
}
