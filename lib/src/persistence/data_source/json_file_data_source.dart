import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';

import '../../../jlogical_utils.dart';

/// File data source that saves its data in json.
class JsonFileDataSource<T> extends FileDataSource<T> {
  JsonFileDataSource({
    required File file,
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) : super(
          file: file,
          persistenceGenerator: _LocalJsonPersistenceGenerator(
            fromJson: (json) => fromJson(json),
            toJson: (obj) => toJson(obj),
          ),
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
