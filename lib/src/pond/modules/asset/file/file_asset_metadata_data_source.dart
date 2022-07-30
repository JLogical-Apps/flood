import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/asset/asset_metadata.dart';

import '../metadata_record/asset_metadata_record.dart';
import '../metadata_record/asset_metadata_record_entity.dart';

class FileAssetMetadataDataSource extends DataSource<AssetMetadata> {
  final String assetId;

  FileAssetMetadataDataSource({required this.assetId});

  @override
  Future<AssetMetadata?> getData() async {
    final file = _getFileFromId(assetId);
    if (!await file.exists()) {
      return null;
    }

    final lastUpdated = await guardAsync(() => file.lastModified());
    final size = await guardAsync(() => file.length());

    final assetMetadataRecordEntity = await Query.from<AssetMetadataRecordEntity>()
        .where(AssetMetadataRecord.assetIdField, isEqualTo: assetId)
        .firstOrNull()
        .get();

    return AssetMetadata(
      lastUpdated: lastUpdated,
      timeCreated: assetMetadataRecordEntity?.value.timeCreated,
      size: size,
    );
  }

  @override
  Future<void> saveData(AssetMetadata data) async {
    final assetMetadataRecordEntity = (await Query.from<AssetMetadataRecordEntity>()
            .where(AssetMetadataRecord.assetIdField, isEqualTo: assetId)
            .firstOrNull()
            .get()) ??
        AssetMetadataRecordEntity();
    final assetMetadataRecord = AssetMetadataRecord()
      ..assetIdProperty.value = assetId
      ..timeCreatedProperty.value = data.timeCreated;

    assetMetadataRecordEntity.value = assetMetadataRecord;

    await assetMetadataRecordEntity.createOrSave();
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  Directory get _baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return _baseDirectory - id;
  }
}
