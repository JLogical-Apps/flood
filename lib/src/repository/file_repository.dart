import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/repository/persistence/persistence_generator.dart';
import 'package:path/path.dart';

/// Repository that stores all the data in a file based on a [PersistenceGenerator].
/// The files are named after the id of the object.
/// The contents of the file are the persisted objects.
abstract class FileRepository<T> implements Repository<T, String> {
  /// Saves and loads objects to files.
  final PersistenceGenerator<T, String> persistenceGenerator;

  /// The directory to store the files in.
  final Directory parentDirectory;

  /// Generates ids for each of the objects in the repository.
  final IdGenerator<T, String> idGenerator;

  /// The file extension for each of the files.
  /// Must start with '.' if not empty.
  final String extension;

  FileRepository(
      {required this.persistenceGenerator,
      required this.parentDirectory,
      required this.idGenerator,
      this.extension: '.txt'});

  @override
  Future<String> create(T object) async {
    var id = idGenerator.getId(object);
    await save(id, object);
    return id;
  }

  @override
  Future<T?> get(String id) async {
    var path = getPath(id);
    var file = File(path);

    if (!await file.exists()) return null;

    try {
      var content = await file.readAsString();
      var object = persistenceGenerator.load(content);
      return object;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(String id, T object) async {
    var path = getPath(id);
    var content = persistenceGenerator.save(object);
    var file = await File(path).ensureCreated();
    await file.writeAsString(content);
  }

  @override
  Future<void> delete(String id) async {
    var path = getPath(id);
    await File(path).delete();
  }

  /// Gets all the elements in the repository with an optional [orderBy] or [filter].
  @override
  Future<PaginationResult<T>> getAll({bool filter(T element)?, int orderBy(T element1, T element2)?}) async {
    await parentDirectory.ensureCreated();

    var fileEntities = await parentDirectory.list().toList();
    var files = fileEntities.whereType<File>();
    var objectByIdEntries = await Future.wait(files.tryMap((file) async {
      var id = basenameWithoutExtension(file.path);
      var object = await get(id);
      return MapEntry<String, T>(id, object!);
    }));
    var elementById = Map.fromEntries(objectByIdEntries);

    if (filter != null) elementById.removeWhere((id, element) => !filter(element));

    if (orderBy != null) {
      var sortedEntries = elementById.entries.toList()..sort((entry1, entry2) => orderBy(entry1.value, entry2.value));
      elementById = Map.fromEntries(sortedEntries);
    }

    return PaginationResult(results: elementById, nextPageGetter: null);
  }

  /// Returns the path of the object with [id].
  String getPath(String id) => join(parentDirectory.path, '$id$extension');
}
