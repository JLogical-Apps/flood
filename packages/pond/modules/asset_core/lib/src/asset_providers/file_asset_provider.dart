import 'dart:io';
import 'dart:typed_data';

import 'package:asset_core/asset_core.dart';
import 'package:environment_core/environment_core.dart';
import 'package:mime/mime.dart';
import 'package:model_core/model_core.dart';
import 'package:path/path.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class FileAssetProvider with IsAssetProvider {
  final AssetCoreComponent context;
  final String path;

  final Map<String, Model<List<int>>> _bytesModelById = {};

  FileAssetProvider({required this.context, required this.path});

  Directory get directory => context.context.environmentCoreComponent.fileSystem.storageIoDirectory! / 'assets' / path;

  @override
  AssetReference getById(String id) {
    final fileModel = DataSource.static.directory(directory).asModel().map((directory) => directory - id);
    final bytesModel = _bytesModelById.putIfAbsent(id, () => DataSource.static.rawFile(directory - id).asModel());
    final metadataModel = Model.union([fileModel, bytesModel]).map((List results) {
      final [File file, List<int> bytes] = results;
      return AssetMetadata(
        size: bytes.length,
        createdTime: file.lastModifiedSync(),
        updatedTime: file.lastModifiedSync(),
        mimeType: lookupMimeType(id) ?? (throw Exception('Could not determine mime type for [$id]')),
      );
    });
    return AssetReference(
      id: id,
      assetMetadataModel: metadataModel,
      assetModel: Model.union([bytesModel, metadataModel]).map((List results) {
        final [List<int> bytes, AssetMetadata metadata] = results;
        return Asset(id: id, value: Uint8List.fromList(bytes), metadata: metadata);
      }),
    ).withFile(directory - id);
  }

  @override
  Future<List<String>> onListIds() async {
    final files = directory.listSync();
    return files.whereType<File>().map((file) => basename(file.path)).toList();
  }

  @override
  Future<Asset> onUpload(Asset asset) async {
    await DataSource.static.rawFile(directory - asset.id).set(asset.value);
    _bytesModelById[asset.id]?.load();
    return asset;
  }

  @override
  Future<void> onDelete(String id) async {
    await DataSource.static.rawFile(directory - id).delete();
  }

  @override
  Future<void> onReset() async {
    await DataSource.static.directory(directory).delete();
  }
}
