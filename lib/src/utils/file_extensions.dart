import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

extension FileExtensions on File {
  /// Reads the json from a file. Throws an exception if the file doesn't exist or cannot be parsed to json.
  Map<String, dynamic> readJsonSync() {
    var text = readAsStringSync();
    return json.decode(text);
  }

  /// Reads the json from a file. Throws an exception if the file doesn't exist or cannot be parsed to json.
  Future<Map<String, dynamic>> readJson() async {
    var text = await readAsString();
    return json.decode(text);
  }

  /// Writes the [_json] to the file. Throws an exception if the file doesn't exist.
  void writeJsonSync(Map<String, dynamic> _json) {
    var jsonText = json.encode(_json);
    writeAsStringSync(jsonText);
  }

  /// Writes the [_json] to the file. Throws an exception if the file doesn't exist.
  Future<void> writeJson(Map<String, dynamic> _json) async {
    var jsonText = json.encode(_json);
    await writeAsString(jsonText);
  }

  /// Returns the file after making sure it is created.
  Future<File> ensureCreated() async {
    await create(recursive: true);
    return this;
  }
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
}
