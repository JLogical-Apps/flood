import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:utils_core/utils_core.dart';

class IoCrossFile with IsCrossFile {
  final File file;

  IoCrossFile({required this.file});

  @override
  Future<void> create() async {
    await file.create(recursive: true);
  }

  @override
  Future<void> delete() async {
    await file.delete();
  }

  @override
  Future<bool> exists() async {
    return await file.exists();
  }

  @override
  String get path => file.path;

  @override
  Future<Uint8List> read() async {
    return await file.readAsBytes();
  }

  @override
  Stream<Uint8List> readX() async* {
    yield* file.watch().asyncMap((event) => file.readAsBytes());
  }

  @override
  Future<void> write(List<int> bytes) async {
    await file.ensureCreated();
    await file.writeAsBytes(bytes);
  }
}
