import 'dart:io';

import 'package:persistence_core/src/crossfile/cross_directory.dart';
import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/crossfile/io/io_cross_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:watcher/watcher.dart';

class IoCrossDirectory with IsCrossDirectory {
  final Directory directory;

  IoCrossDirectory({required this.directory});

  final BehaviorSubject _refreshSubject = BehaviorSubject.seeded(null);

  @override
  Future<void> create() async {
    await directory.create(recursive: true);
    _refreshSubject.value = null;
  }

  @override
  Future<void> delete() async {
    await directory.delete(recursive: true);
    _refreshSubject.value = null;
  }

  @override
  Future<bool> exists() async {
    return await directory.exists();
  }

  @override
  CrossDirectory getDirectory(String path) {
    return IoCrossDirectory(directory: directory / path);
  }

  @override
  CrossFile getFile(String path) {
    return IoCrossFile(file: directory - path);
  }

  @override
  Future<List<CrossElement>?> listOrNull() async {
    if (!await directory.exists()) {
      return null;
    }

    final elements = directory.listSync();
    return elements
        .map((element) {
          if (element is File) {
            return IoCrossFile(file: element);
          } else if (element is Directory) {
            return IoCrossDirectory(directory: element);
          }
          return null;
        })
        .whereNonNull()
        .toList();
  }

  @override
  Stream<List<CrossElement>?> listX() {
    return Rx.merge<dynamic>([
      DirectoryWatcher(directory.path).events,
      _refreshSubject,
    ]).asyncMap((_) => listOrNull());
  }

  @override
  String get path => directory.path;
}
