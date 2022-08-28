import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:mime/mime.dart';

import 'asset_metadata.dart';

class Asset {
  final String? id;
  final Uint8List value;

  /// The metadata of the asset. [null] if it hasn't been retrieved from an AssetProvider.
  final AssetMetadata? metadata;

  late final String? mimeType = name.mapIfNonNull((name) => lookupMimeType(name));

  Asset({this.id, required this.value, required this.metadata});

  Asset.createNew({this.id, required this.value}) : metadata = null;

  String? get name => id;

  static Future<Asset> fromFile(File file, {String? id}) async {
    if (!await file.exists()) {
      throw Exception('Cannot get asset from file [${file.path}]');
    }

    final fileData = await file.readAsBytes();
    return Asset(
      id: id,
      value: fileData,
      metadata: AssetMetadata(
        lastUpdated: await file.lastModified(),
        timeCreated: DateTime.now(),
        size: await file.length(),
      ),
    );
  }

  Asset copyWith({String? id, Uint8List? value, AssetMetadata? metadata}) {
    return Asset(
      id: id ?? this.id,
      value: value ?? this.value,
      metadata: metadata ?? this.metadata,
    );
  }

  Future<File?> cacheToFile() async {
    if (kIsWeb) {
      return null;
    }

    final file = AppContext.global.cacheDirectory - name!;
    await file.writeAsBytes(value);
    return file;
  }

  Future<File?> ensureCachedToFile() async {
    if (kIsWeb) {
      return null;
    }

    final file = AppContext.global.cacheDirectory - name!;
    if (await file.exists()) {
      return file;
    }

    return await cacheToFile();
  }

  Future<void> clearCachedFile() async {
    if (kIsWeb) {
      return;
    }

    final file = AppContext.global.cacheDirectory - name!;
    if (await file.exists()) {
      await file.delete();
    }
  }

  bool get isImage => mimeType?.startsWith('image') == true;

  bool get isVideo => mimeType?.startsWith('video') == true;

  bool get isText => mimeType?.startsWith('text') == true;

  bool get isBinary => mimeType?.startsWith('application') == true;
}
