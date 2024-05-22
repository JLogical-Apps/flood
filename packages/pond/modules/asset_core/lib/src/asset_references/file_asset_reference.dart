import 'dart:io';

import 'package:asset_core/asset_core.dart';

class FileAssetReference with IsAssetReferenceWrapper {
  @override
  final AssetReference assetReference;

  final File file;

  FileAssetReference({required this.assetReference, required this.file});
}
