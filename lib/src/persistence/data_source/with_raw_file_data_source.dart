import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:pool/pool.dart';

mixin WithRawFileDataSource on DataSource<Uint8List> {
  static Pool _filePool = Pool(10);

  /// The file this is pointing to.
  File get file;

  @override
  Future<bool> exists() {
    return file.exists();
  }

  Future<Uint8List?> getData() async {
    if (!await file.exists()) return null;

    return await _filePool.withResource(() => guardAsync(() => file.readAsBytes()));
  }

  Future<void> saveData(Uint8List data) async {
    await _filePool.withResource(() async {
      await file.ensureCreated();
      await file.writeAsBytes(data);
    });
  }

  Future<void> delete() async {
    if (!await file.exists()) return;

    await file.delete();
  }
}
