import 'dart:io';

import 'package:persistence_core/src/data_source.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watcher/watcher.dart';

class DirectoryDataSource extends DataSource<Directory> {
  final Directory directory;

  DirectoryDataSource({required this.directory});

  @override
  Stream<Directory>? getXOrNull() async* {
    yield (await getOrNull()) ?? directory;

    yield* DirectoryWatcher(directory.path).events.asyncMap((_) => getOrNull()).whereNotNull();
  }

  @override
  Future<Directory?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return directory;
  }

  @override
  Future<bool> exists() {
    return directory.exists();
  }

  @override
  Future<void> set(Directory data) async {
    throw Exception('Cannot set the data for a DirectoryDataSource!');
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await directory.delete(recursive: true);
  }
}
