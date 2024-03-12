import 'dart:async';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_file.dart';

class BytesCrossFile with IsCrossFile {
  @override
  final String path;
  final FutureOr<Uint8List> Function() bytesGetter;

  BytesCrossFile({required this.path, required this.bytesGetter});

  @override
  Future<void> create() {
    throw Exception('Cannot create a CrossFile.static.fromBytes()!');
  }

  @override
  Future<void> delete() {
    throw Exception('Cannot delete a CrossFile.static.fromBytes()!');
  }

  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  Future<Uint8List> read() async {
    return await bytesGetter();
  }

  @override
  Stream<Uint8List> readX() {
    return Stream.fromFuture(read());
  }

  @override
  Future<void> write(List<int> bytes) {
    throw Exception('Cannot write to a CrossFile.static.fromBytes()!');
  }
}
