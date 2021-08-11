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

  /// The default sorter that will be used for [getAll] if none is provided.
  /// If [null], then the sort is
  final int Function(T element1, T element2)? defaultSorter;

  LocalRepository({List<T>? initialValues, required this.idGenerator, this.defaultSorter})
      : dataById = Map.fromEntries((initialValues ?? []).map((value) => MapEntry(idGenerator.getId(value), value)));

  @override
  Future<R> generateId() async {
    return idGenerator.getId(null);
  }

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

  /// Gets all the elements in the repository with an optional [orderBy] or [filter].
  @override
  Future<PaginationResult<T>> getAll({bool filter(T element)?, int orderBy(T element1, T element2)?}) async {
    orderBy ??= defaultSorter;

    var elementById = dataById.map((key, value) => MapEntry(key.toString(), value));

    if (filter != null) elementById.removeWhere((id, element) => !filter(element));

    if (orderBy != null) {
      var sortedEntries = elementById.entries.toList()..sort((entry1, entry2) => orderBy!(entry1.value, entry2.value));
      elementById = Map.fromEntries(sortedEntries);
    }

    return PaginationResult(results: elementById, nextPageGetter: null);
  }
}
