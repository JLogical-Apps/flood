import 'dart:io';

import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/crossfile/io/io_cross_directory.dart';

abstract class CrossDirectory implements CrossElement {
  CrossDirectory getDirectory(String path);

  CrossFile getFile(String path);

  Stream<List<CrossElement>?> listX();

  Future<List<CrossElement>?> listOrNull();

  static CrossDirectoryStatic get static => CrossDirectoryStatic();
}

class CrossDirectoryStatic {
  CrossDirectory io(Directory directory) => IoCrossDirectory(directory: directory);
}

extension CrossDirectoryExtensions on CrossDirectory {
  CrossDirectory operator /(String path) {
    if (path == '.') {
      return this;
    }

    return getDirectory(path);
  }

  CrossFile operator -(String path) {
    return getFile(path);
  }

  Future<List<CrossElement>> list() async {
    return (await listOrNull()) ?? (throw Exception('Could not list files at [$path]!'));
  }
}

mixin IsCrossDirectory implements CrossDirectory {}
