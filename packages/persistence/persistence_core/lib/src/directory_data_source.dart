import 'dart:io';

import 'package:persistence_core/src/data_source.dart';
import 'package:watcher/watcher.dart';

class DirectoryDataSource extends DataSource<List<FileSystemEntity>?> {
  final Directory directory;

  DirectoryDataSource({required this.directory});

  @override
  Stream<List<FileSystemEntity>?>? getXOrNull() async* {
    yield await getOrNull();

    yield* DirectoryWatcher(directory.path).events.asyncMap((_) => getOrNull());
  }

  @override
  Future<List<FileSystemEntity>?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return directory.listSync().toList();
  }

  @override
  Future<bool> exists() {
    return directory.exists();
  }

  @override
  Future<void> set(List<FileSystemEntity>? data) async {
    throw Exception('Cannot set the data for a DirectoryDataSource!');
  }

  @override
  Future<void> delete() async {
    throw Exception('Cannot delete the data for a DirectoryDataSource!');
  }
}
