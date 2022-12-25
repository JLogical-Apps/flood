import 'dart:io';

import 'package:persistence_core/src/data_source.dart';
import 'package:utils_core/utils_core.dart';

class FileDataSource extends DataSource<String> {
  final File file;

  FileDataSource({required this.file});

  @override
  Stream<String>? getXOrNull() async* {
    if (!await exists()) {
      return;
    }

    yield* file.watch().asyncMap((event) => file.readAsString());
  }

  @override
  Future<String?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return await file.readAsString();
  }

  @override
  Future<bool> exists() {
    return file.exists();
  }

  @override
  Future<void> set(String data) async {
    await file.ensureCreated();
    await file.writeAsString(data);
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await file.delete();
  }
}
