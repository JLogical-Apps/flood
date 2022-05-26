import 'dart:io';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_provider.dart';

class FileAssetProvider extends AssetProvider {
  @override
  DataSource<Asset> getDataSource(String id) {
    return RawFileDataSource(file: _getFileFromId(id)).map(
      onLoad: (bytes) {
        return bytes.mapIfNonNull((bytes) => Asset(id: id, name: id, value: bytes));
      },
      onSave: (asset) {
        return asset.value;
      },
    );
  }

  Directory get _baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return _baseDirectory - id;
  }
}
