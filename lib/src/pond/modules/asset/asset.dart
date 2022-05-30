import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:mime/mime.dart';

class Asset {
  final String? id;
  final String name;
  final Uint8List value;

  late final String? mimeType = lookupMimeType(name);

  Asset({this.id, required this.name, required this.value});

  Asset withValue(Uint8List newValue) {
    return Asset(id: id, name: name, value: newValue);
  }

  Future<File> cacheToFile() async {
    final file = AppContext.global.cacheDirectory - name;
    await file.writeAsBytes(value);
    return file;
  }

  Future<File> ensureCachedToFile() async {
    final file = AppContext.global.cacheDirectory - name;
    if (await file.exists()) {
      return file;
    }

    return await cacheToFile();
  }

  Future<void> clearCachedFile() async {
    final file = AppContext.global.cacheDirectory - name;
    if (await file.exists()) {
      await file.delete();
    }
  }

  bool get isImage => mimeType?.startsWith('image') == true;

  bool get isVideo => mimeType?.startsWith('video') == true;

  bool get isText => mimeType?.startsWith('text') == true;

  bool get isBinary => mimeType?.startsWith('application') == true;
}
