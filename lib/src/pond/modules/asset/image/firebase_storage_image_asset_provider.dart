import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../../persistence/export.dart';
import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import 'image_asset_provider.dart';

class FirebaseStorageImageAssetProvider extends ImageAssetProvider {
  final Directory cacheDirectory;

  FirebaseStorageImageAssetProvider({Directory? cacheDirectory})
      : this.cacheDirectory = cacheDirectory ?? AppContext.global.cacheDirectory / 'image';

  @override
  DataSource<Uint8List> getDataSource(String id) {
    return FirebaseStorageDataSource(storagePath: id).withCache(RawFileDataSource(file: _getCacheFile(id)));
  }

  File _getCacheFile(String id) {
    return cacheDirectory - id;
  }
}
