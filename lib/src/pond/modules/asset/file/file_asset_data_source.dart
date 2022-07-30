import 'dart:io';

import 'package:jlogical_utils/jlogical_utils_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';

import '../asset.dart';
import '../asset_metadata.dart';
import 'file_asset_metadata_data_source.dart';

class FileAssetDataSource extends DataSource<Asset> {
  final String assetId;

  FileAssetDataSource({required this.assetId});

  late RawFileDataSource fileDataSource = RawFileDataSource(file: _getFileFromId(assetId));
  late FileAssetMetadataDataSource assetMetadataDataSource = FileAssetMetadataDataSource(assetId: assetId);

  @override
  Future<Asset?> getData() async {
    final assetValue = await fileDataSource.getData();
    if (assetValue == null) {
      return null;
    }

    final metadata = (await assetMetadataDataSource.getData()) ?? AssetMetadata.now(size: assetValue.length);

    return Asset(id: assetId, metadata: metadata, value: assetValue);
  }

  @override
  Future<void> saveData(Asset asset) async {
    await fileDataSource.saveData(asset.value);
    await assetMetadataDataSource.saveData(asset.metadata ?? AssetMetadata.now(size: asset.value.length));
  }

  @override
  Future<void> delete() async {
    await fileDataSource.delete();
  }

  static Directory get baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return baseDirectory - id;
  }
}
