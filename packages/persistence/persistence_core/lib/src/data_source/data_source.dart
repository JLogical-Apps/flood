import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:persistence_core/src/data_source/base64_data_source.dart';
import 'package:persistence_core/src/data_source/cache_data_source.dart';
import 'package:persistence_core/src/data_source/cross_directory_data_source.dart';
import 'package:persistence_core/src/data_source/cross_file_data_source.dart';
import 'package:persistence_core/src/data_source/csv_data_source.dart';
import 'package:persistence_core/src/data_source/directory_data_source.dart';
import 'package:persistence_core/src/data_source/file_data_source.dart';
import 'package:persistence_core/src/data_source/json_data_source.dart';
import 'package:persistence_core/src/data_source/mapper_data_source.dart';
import 'package:persistence_core/src/data_source/memory_data_source.dart';
import 'package:persistence_core/src/data_source/raw_cross_file_data_source.dart';
import 'package:persistence_core/src/data_source/raw_file_data_source.dart';
import 'package:persistence_core/src/data_source/yaml_data_source.dart';
import 'package:persistence_core/src/utils/create_archive.dart';

abstract class DataSource<T> {
  Stream<T>? getXOrNull();

  Future<void> set(T data);

  Future<void> delete();

  Future<T?> getOrNull();

  Future<bool> exists();

  static DataSourceStatic get static => DataSourceStatic();
}

class DataSourceStatic {
  MemoryDataSource<T> memory<T>({T? initialData}) {
    return MemoryDataSource(initialData: initialData);
  }

  DirectoryDataSource directory(Directory directory) {
    return DirectoryDataSource(directory: directory);
  }

  FileDataSource file(File file) {
    return FileDataSource(file: file);
  }

  RawFileDataSource rawFile(File file) {
    return RawFileDataSource(file: file);
  }

  CrossFileDataSource crossFile(CrossFile file) {
    return CrossFileDataSource(file: file);
  }

  RawCrossFileDataSource rawCrossFile(CrossFile file) {
    return RawCrossFileDataSource(file: file);
  }

  CrossDirectoryDataSource crossDirectory(CrossDirectory directory) {
    return CrossDirectoryDataSource(directory: directory);
  }

  UrlDataSource url(Uri url) {
    return UrlDataSource(url: url);
  }
}

extension DataSourceExtension<T> on DataSource<T> {
  Stream<T> getX() {
    return getXOrNull() ?? (throw Exception('Could not get data stream for [$this]'));
  }

  Future<T> get() async {
    return (await getOrNull()) ?? (throw Exception('Could not get data for [$this]'));
  }

  Future<T> update(T Function(T? existingData) newDataGetter) async {
    final existingData = await getOrNull();
    final newData = newDataGetter(existingData);
    await set(newData);
    return newData;
  }

  CacheDataSource<T> withCache([CachePolicy? cachePolicy]) {
    return CacheDataSource(dataSource: this, cachePolicy: cachePolicy);
  }

  MapperDataSource<T, T2> map<T2>({
    required FutureOr<T2> Function(T data) getMapper,
    FutureOr<bool> Function(T? data)? existsMapper,
    required FutureOr<T> Function(T2 data) setMapper,
    FutureOr<void> Function()? deleteMapper,
  }) {
    return MapperDataSource(
      dataSource: this,
      getMapper: getMapper,
      existsMapper: existsMapper,
      setMapper: setMapper,
      deleteMapper: deleteMapper,
    );
  }

  MapperDataSource<T, T2> mapGet<T2>(
    FutureOr<T2> Function(T data) getMapper, {
    FutureOr<bool> Function(T? data)? existsMapper,
  }) {
    return map(
      getMapper: getMapper,
      setMapper: (_) => throw UnimplementedError('Cannot save this Data Source'),
      existsMapper: existsMapper,
      deleteMapper: () => throw UnimplementedError('Cannot delete this Data Source'),
    );
  }
}

extension StringDataSourceExtensions on DataSource<String> {
  YamlDataSource mapYaml() => YamlDataSource(sourceDataSource: this);

  JsonDataSource mapJson() => JsonDataSource(sourceDataSource: this);

  CsvDataSource mapCsv({bool? hasHeaderRow}) => CsvDataSource(
        sourceDataSource: this,
        hasHeaderRow: hasHeaderRow ?? false,
      );

  Base64DataSource mapBase64() => Base64DataSource(sourceDataSource: this);
}

extension DirectoryDataSourceExtensions on DataSource<Directory> {
  DataSource<List<int>> mapTar({List<Pattern> ignorePatterns = const []}) => mapGet(
        (directory) => TarEncoder().encode(directory.createArchive(ignorePatterns: ignorePatterns)),
      );
}

extension RawDataSourceExtensions on DataSource<List<int>> {
  DataSource<List<int>> mapGzip() => map(
        getMapper: (data) => GZipEncoder().encode(data)!,
        setMapper: (data) => GZipDecoder().decodeBytes(data),
      );
}

mixin IsDataSource<T> implements DataSource<T> {
  @override
  Future<T?> getOrNull() {
    return getXOrNull()?.first ?? Future.value(null);
  }

  @override
  Future<bool> exists() async {
    final data = await getOrNull();
    return data != null;
  }
}

abstract class DataSourceWrapper<T> implements DataSource<T> {
  DataSource<T> get dataSource;
}

mixin IsDataSourceWrapper<T> implements DataSourceWrapper<T> {
  @override
  Future<T?> getOrNull() => dataSource.getOrNull();

  @override
  Stream<T>? getXOrNull() {
    return dataSource.getXOrNull();
  }

  @override
  Future<void> set(T data) => dataSource.set(data);

  @override
  Future<void> delete() => dataSource.delete();

  @override
  Future<bool> exists() => dataSource.exists();
}
