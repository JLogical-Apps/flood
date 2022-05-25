import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'image_asset.dart';
import 'image_asset_provider.dart';

class FileImageAssetProvider extends ImageAssetProvider {
  @override
  Future<ImageAsset> create(Uint8List value) async {
    final id = UuidIdGenerator().getId();
    final dataSource = RawFileDataSource(file: _getFileFromId(id));

    final asset = ImageAsset(id: id, isOnlyLocal: true, dataSource: dataSource);
    asset.value = value;
    await asset.uploadIfNonexistent();
    return asset;
  }

  @override
  ImageAsset from(String id) {
    return ImageAsset(id: id, isOnlyLocal: false, dataSource: RawFileDataSource(file: _getFileFromId(id)));
  }

  Directory get _baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return _baseDirectory - id;
  }
}
