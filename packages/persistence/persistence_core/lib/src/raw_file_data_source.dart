import 'dart:io';

import 'package:persistence_core/src/data_source.dart';
import 'package:utils_core/utils_core.dart';

class RawFileDataSource extends DataSource<List<int>> {
  final File file;

  RawFileDataSource({required this.file});

  @override
  Stream<List<int>>? getXOrNull() async* {
    if (!await exists()) {
      return;
    }

    yield* file.watch().asyncMap((event) => file.readAsBytes());
  }

  @override
  Future<List<int>?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return await file.readAsBytes();
  }

  @override
  Future<bool> exists() {
    return file.exists();
  }

  @override
  Future<void> set(List<int> data) async {
    await file.ensureCreated();
    await file.writeAsBytes(data);
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await file.delete();
  }
}
