import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/bytes_cross_filter.dart';
import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/io/io_cross_file.dart';
import 'package:persistence_core/src/crossfile/readonly_cross_file.dart';

abstract class CrossFile implements CrossElement {
  Stream<Uint8List> readX();

  Future<Uint8List> read();

  Future<void> write(List<int> bytes);

  static CrossFileStatic get static => CrossFileStatic();
}

class CrossFileStatic {
  CrossFile io(File file) => IoCrossFile(file: file);

  CrossFile fromBytes({required String path, required FutureOr<Uint8List> Function() bytesGetter}) =>
      BytesCrossFile(path: path, bytesGetter: bytesGetter);
}

extension CrossFileExtensions on CrossFile {
  Future<String> readAsString() async {
    return utf8.decode(await read());
  }

  Future<void> writeAsString(String text) async {
    await write(utf8.encode(text));
  }

  CrossFile readonly() {
    return ReadonlyCrossFile(crossFile: this);
  }
}

mixin IsCrossFile implements CrossFile {}

abstract class CrossFileWrapper implements CrossFile {
  CrossFile get crossFile;
}

mixin IsCrossFileWrapper implements CrossFileWrapper {
  @override
  Stream<Uint8List> readX() => crossFile.readX();

  @override
  Future<Uint8List> read() => crossFile.read();

  @override
  Future<void> write(List<int> bytes) => crossFile.write(bytes);

  @override
  String get path => crossFile.path;

  @override
  Future<void> create() => crossFile.create();

  @override
  Future<bool> exists() => crossFile.exists();

  @override
  Future<void> delete() => crossFile.delete();
}
