import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:pool/pool.dart';

mixin WithFileDataSource on DataSource<String> {
  static Pool _filePool = Pool(10);

  /// The file this is pointing to.
  File get file;

  @override
  Future<bool> exists() {
    return file.exists();
  }

  Future<String?> getData() async {
    if (!await file.exists()) return null;

    return await _filePool.withResource(() => file.readAsString());
  }

  Future<void> saveData(String persisted) async {
    await _filePool.withResource(() async {
      await file.ensureCreated();
      await file.writeAsString(persisted);
    });
  }

  Future<void> delete() async {
    if (!await file.exists()) return;

    await file.delete();
  }
}
