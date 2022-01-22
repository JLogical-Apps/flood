import 'package:jlogical_utils/src/persistence/data_source/mappers/data_source_mapper.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/json_data_source_mapper.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/yaml_data_source_mapper.dart';

/// A data source is a special service that reads and updates data from a particular source.
/// [T] is the type of data this data source points to.
abstract class DataSource<T> {
  /// Returns the data at the data source or null if not found.
  Future<T?> getData();

  /// Saves [data] into the data source.
  Future<void> saveData(T data);

  /// Deletes the data source.
  Future<void> delete();
}

extension DataSourceExtensions<T> on DataSource<T> {
  DataSourceMapper<T, T2> map<T2>({required T Function(T2 obj) onSave, required T2? Function(T? persisted) onLoad}) =>
      DataSourceMapper(
        parent: this,
        onSave: onSave,
        onLoad: onLoad,
      );
}

extension StringDataSourceExtensions on DataSource<String> {
  JsonDataSourceMapper mapJson() => JsonDataSourceMapper(parent: this);

  YamlDataSourceMapper mapYaml() => YamlDataSourceMapper(parent: this);
}
