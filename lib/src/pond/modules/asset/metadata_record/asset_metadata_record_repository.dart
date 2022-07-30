import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/asset/metadata_record/asset_metadata_record.dart';

import 'asset_metadata_record_entity.dart';

class AssetMetadataRecordRepository extends DefaultFileRepository<AssetMetadataRecordEntity, AssetMetadataRecord> {
  @override
  String get dataPath => 'asset_metadata';

  @override
  AssetMetadataRecordEntity createEntity() {
    return AssetMetadataRecordEntity();
  }

  @override
  AssetMetadataRecord createValueObject() {
    return AssetMetadataRecord();
  }
}
