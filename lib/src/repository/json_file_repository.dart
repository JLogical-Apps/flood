import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/repository/persistence/json_persistence_generator.dart';

/// File repository that saves objects in json format.
abstract class JsonFileRepository<T> extends FileRepository<T> {
  JsonFileRepository({
    required Directory parentDirectory,
    required IdGenerator<T, String> idGenerator,
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
    int defaultSorter(T element1, T element2)?,
  }) : super(
          idGenerator: idGenerator,
          parentDirectory: parentDirectory,
          extension: '.json',
          persistenceGenerator: _LocalJsonPersistenceGenerator(
            fromJson: (json) => fromJson(json),
            toJson: (obj) => toJson(obj),
          ),
          defaultSorter: defaultSorter,
        );
}

class _LocalJsonPersistenceGenerator<T> extends JsonPersistenceGenerator<T> {
  final T Function(Map<String, dynamic> jsonObject) _fromJson;
  final Map<String, dynamic> Function(T object) _toJson;

  _LocalJsonPersistenceGenerator(
      {required T fromJson(Map<String, dynamic> jsonObject), required Map<String, dynamic> toJson(T object)})
      : _fromJson = fromJson,
        _toJson = toJson;

  @override
  T fromJson(Map<String, dynamic> json) => this._fromJson(json);

  @override
  Map<String, dynamic> toJson(T object) => this._toJson(object);
}
