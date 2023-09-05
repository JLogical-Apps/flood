import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/io/io_cross_file.dart';
import 'package:persistence_core/src/crossfile/web/web_cross_file.dart';

abstract class CrossFile implements CrossElement {
  Stream<Uint8List> readX();

  Future<Uint8List> read();

  Future<void> write(List<int> bytes);

  static CrossFile io(File file) => IoCrossFile(file: file);

  static CrossFile web(String path) => WebCrossFile(path: path);
}

extension CrossFileExtensions on CrossFile {
  Future<String> readAsString() async {
    return utf8.decode(await read());
  }

  Future<void> writeAsString(String text) async {
    await write(utf8.encode(text));
  }
}

mixin IsCrossFile implements CrossFile {}
