import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

mixin WithFileDataSource on DataSource<String> {
  /// The file this is pointing to.
  File get file;

  @override
  Future<bool> exists() {
    return file.exists();
  }

  Future<String?> getData() async {
    if (!await file.exists()) return null;

    return await file.readAsString();
  }

  Future<void> saveData(String persisted) async {
    await file.ensureCreated();
    await file.writeAsString(persisted);
  }

  Future<void> delete() async {
    if (!await file.exists()) return;

    await file.delete();
  }
}
