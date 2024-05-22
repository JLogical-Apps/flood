import 'dart:io';

import 'package:asset_core/src/asset_references/file_asset_reference.dart';
import 'package:asset_core/src/asset_references/meta/asset_reference_meta_modifier.dart';

class FileAssetReferenceMetaModifier extends WrapperAssetReferenceMetaModifier<FileAssetReference> {
  @override
  File? getFile(FileAssetReference assetReference) {
    return assetReference.file;
  }
}
