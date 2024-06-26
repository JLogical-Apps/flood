import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

extension FileExtensions on File {
  /// Reads the json from a file. Throws an exception if the file doesn't exist or cannot be parsed to json.
  Map<String, dynamic> readJsonSync() {
    final text = readAsStringSync();
    return json.decode(text);
  }

  /// Reads the json from a file. Throws an exception if the file doesn't exist or cannot be parsed to json.
  Future<Map<String, dynamic>> readJson() async {
    final text = await readAsString();
    return json.decode(text);
  }

  /// Writes the [jsonData] to the file. Throws an exception if the file doesn't exist.
  void writeJsonSync(Map<String, dynamic> jsonData) {
    final jsonText = json.encode(jsonData);
    writeAsStringSync(jsonText);
  }

  /// Writes the [jsonData] to the file. Throws an exception if the file doesn't exist.
  Future<void> writeJson(Map<String, dynamic> jsonData) async {
    final jsonText = json.encode(jsonData);
    await writeAsString(jsonText);
  }

  /// Returns the file after making sure it is created.
  Future<File> ensureCreated() async {
    await create(recursive: true);
    return this;
  }

  String get relativePath => relative(path).replaceAll('\\', '/');
}

extension DirectoryExtensions on Directory {
  /// Returns the directory after making sure it is created.
  Future<Directory> ensureCreated() async {
    await create(recursive: true);
    return this;
  }

  /// Returns the directory with [path] appended.
  Directory operator /(String path) {
    return Directory(join(this.path, path));
  }

  /// Returns the file with [path] appended.
  File operator -(String path) {
    return File(join(this.path, path));
  }

  String get relativePath => relative(path).replaceAll('\\', '/');

  /// Returns a chain of directories starting with this one up each parent.
  Iterable<Directory> getChain() sync* {
    var directory = this;
    while (directory.path != '/') {
      yield directory;
      directory = directory.parent;
    }
  }

  Future<Directory> copyTo(Directory destination) async {
    await destination.ensureCreated();
    for (final fileElement in listSync(recursive: true)) {
      final fileElementBasename = basename(fileElement.path);
      if (fileElement is File) {
        await fileElement.copy((destination - fileElementBasename).path);
      } else if (fileElement is Directory) {
        await fileElement.copyTo(destination / fileElementBasename);
      }
    }

    return destination;
  }
}
