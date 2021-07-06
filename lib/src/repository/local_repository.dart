import 'package:flutter/material.dart';

import '../../jlogical_utils.dart';
import 'ids/id_generator.dart';

/// Repository that stores all the data as a map locally.
class LocalRepository<T, R> implements Repository<T, R> {
  /// Maps the id of data to its value.
  @protected
  final Map<R, T> dataById;

  /// Generates ids for each of the objects in the repository.
  final IdGenerator<T, R> idGenerator;

  LocalRepository({List<T>? initialValues, required this.idGenerator}) : dataById = Map.fromEntries((initialValues ?? []).map((value) => MapEntry(idGenerator.getId(value), value)));

  @override
  Future<R> create(T object) async {
    var id = idGenerator.getId(object);
    dataById[id] = object;
    return id;
  }

  @override
  Future<T?> get(R id) async {
    return dataById[id];
  }

  @override
  Future<void> save(R id, T object) async {
    dataById[id] = object;
  }

  @override
  Future<void> delete(R id) async {
    dataById.remove(id);
  }

  @override
  Future<PaginationResult<T>> getAll() async {
    return PaginationResult(results: dataById.map((key, value) => MapEntry(key.toString(), value)), nextPageGetter: null);
  }
}
