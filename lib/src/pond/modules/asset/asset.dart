import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class Asset {
  final String? id;
  final String name;
  final Uint8List value;

  const Asset({this.id, required this.name, required this.value});

  Future<File> cacheToFile() async {
    final file = AppContext.global.cacheDirectory - name;
    await file.writeAsBytes(value);
    return file;
  }
}
