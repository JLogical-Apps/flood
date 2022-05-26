import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import 'image_asset_provider.dart';

class FileImageAssetProvider extends ImageAssetProvider {
  @override
  DataSource<Uint8List> getDataSource(String id) {
    return RawFileDataSource(file: _getFileFromId(id));
  }

  Directory get _baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return _baseDirectory - id;
  }
}
