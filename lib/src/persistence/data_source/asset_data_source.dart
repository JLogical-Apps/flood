import 'package:jlogical_utils/src/persistence/data_source/with_asset_data_source.dart';

import 'data_source.dart';

class AssetDataSource extends DataSource<String> with WithAssetDataSource {
  final String assetPath;

  AssetDataSource({required this.assetPath});
}
