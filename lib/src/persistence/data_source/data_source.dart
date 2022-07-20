import 'dart:async';

import 'package:jlogical_utils/src/persistence/data_source/mappers/data_source_mapper.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/json_data_source_mapper.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/yaml_data_source_mapper.dart';

import 'cached_data_source.dart';

/// A data source is a special service that reads and updates data from a particular source.
/// [T] is the type of data this data source points to.
abstract class DataSource<T> {
  /// Returns the data at the data source or null if not found.
  Future<T?> getData();

  /// Saves [data] into the data source.
  Future<void> saveData(T data);

  /// Deletes the data source.
  Future<void> delete();

  /// Returns whether data already exists at this source.
  Future<bool> exists() async {
    return (await getData()) != null;
  }
}

extension DataSourceExtensions<T> on DataSource<T> {
  DataSourceMapper<T, T2> map<T2>({required FutureOr<T> Function(T2 obj) onSave, required FutureOr<T2?> Function(T? persisted) onLoad}) =>
      DataSourceMapper(
        parent: this,
        onSave: onSave,
        onLoad: onLoad,
      );

  DataSourceMapper<T, T2> mapLoad<T2>({required T2? Function(T? persisted) onLoad}) => DataSourceMapper(
        parent: this,
        onSave: (_) => throw UnimplementedError(),
        onLoad: onLoad,
      );

  CachedDataSource<T> withCache(DataSource<T> cacheDataSource) {
    return CachedDataSource(sourceDataSource: this, cacheDataSource: cacheDataSource);
  }
}

extension StringDataSourceExtensions on DataSource<String> {
  JsonDataSourceMapper mapJson() => JsonDataSourceMapper(parent: this);

  YamlDataSourceMapper mapYaml() => YamlDataSourceMapper(parent: this);
}
