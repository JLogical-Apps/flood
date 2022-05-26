import 'dart:typed_data';

import '../../../../persistence/export_core.dart';
import 'image_asset_provider.dart';

class LocalImageAssetProvider extends ImageAssetProvider {
  @override
  DataSource<Uint8List> getDataSource(String id) {
    return LocalDataSource();
  }
}
