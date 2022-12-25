import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/data_source.dart';
import 'package:utils_core/utils_core.dart';

class RawFileDataSource extends DataSource<Uint8List> {
  final File file;

  RawFileDataSource({required this.file});

  @override
  Stream<Uint8List>? getXOrNull() async* {
    if (!await exists()) {
      return;
    }

    yield* file.watch().asyncMap((event) => file.readAsBytes());
  }

  @override
  Future<Uint8List?> getOrNull() async {
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
  Future<void> set(Uint8List data) async {
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
