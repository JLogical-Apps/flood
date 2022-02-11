import 'package:flutter/services.dart';
import 'package:jlogical_utils/src/persistence/data_source/with_raw_asset_data_source.dart';

import 'data_source.dart';

class RawAssetDataSource extends DataSource<ByteData> with WithRawAssetDataSource {
  final String assetPath;

  RawAssetDataSource({required this.assetPath});
}
