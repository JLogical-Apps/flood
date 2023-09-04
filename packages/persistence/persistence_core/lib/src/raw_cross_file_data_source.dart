import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/data_source.dart';

class RawCrossFileDataSource extends DataSource<Uint8List> {
  final CrossFile file;

  RawCrossFileDataSource({required this.file});

  @override
  Stream<Uint8List>? getXOrNull() async* {
    if (!await exists()) {
      return;
    }

    yield* file.readX();
  }

  @override
  Future<Uint8List?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return await file.read();
  }

  @override
  Future<bool> exists() {
    return file.exists();
  }

  @override
  Future<void> set(Uint8List data) async {
    await file.ensureCreated();
    await file.write(data);
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await file.delete();
  }
}
