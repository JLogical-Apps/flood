import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

import '../../../jlogical_utils.dart';

/// Data source that points to a file.
/// The contents of the file is the persisted data.
class FileDataSource<T> extends DataSource<T> {
  /// The file this is pointing to.
  final File file;

  /// Saves and loads the data to the file.
  final PersistenceGenerator<T, String> persistenceGenerator;

  FileDataSource({required this.file, required this.persistenceGenerator});

  @override
  Future<T?> getData() async {
    if (!await file.exists()) return null;

    try {
      final content = await file.readAsString();
      final object = persistenceGenerator.load(content);
      return object;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveData(T data) async {
    final content = persistenceGenerator.save(data);
    await file.ensureCreated();
    await file.writeAsString(content);
  }

  Future<void> delete() async {
    if (!await file.exists()) return;

    await file.delete();
  }
}
