import 'dart:io';

import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_metadata.dart';
import 'asset_provider.dart';

class FileAssetProvider extends AssetProvider {
  @override
  DataSource<Asset> getDataSource(String id) {
    final file = _getFileFromId(id);
    return RawFileDataSource(file: file).map(
      onLoad: (bytes) async {
        final assetMetadata = await getMetadataDataSource(id).getData();
        return bytes.mapIfNonNull((bytes) => Asset(
              id: id,
              value: bytes,
              metadata: assetMetadata!,
            ));
      },
      onSave: (asset) {
        return asset.value;
      },
    );
  }

  @override
  DataSource<AssetMetadata> getMetadataDataSource(String id) {
    return CustomDataSource(
      onGet: () async {
        final file = _getFileFromId(id);
        final lastUpdated = await guardAsync(() => file.lastModified());
        return AssetMetadata(lastUpdated: lastUpdated);
      },
      onSave: (metadata) => throw UnimplementedError(),
      onDelete: () => throw UnimplementedError(),
    );
  }

  Directory get _baseDirectory => AppContext.global.supportDirectory / 'assets' / 'images';

  File _getFileFromId(String id) {
    return _baseDirectory - id;
  }
}
