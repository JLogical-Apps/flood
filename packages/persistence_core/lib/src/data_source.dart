import 'dart:async';
import 'dart:io';

import 'package:persistence_core/src/file_data_source.dart';
import 'package:persistence_core/src/mapper_data_source.dart';
import 'package:persistence_core/src/memory_data_source.dart';
import 'package:persistence_core/src/raw_file_data_source.dart';

abstract class DataSource<T> {
  Stream<T>? getXOrNull();

  Future<void> set(T data);

  Future<void> delete();

  Future<T?> getOrNull() {
    return getXOrNull()?.first ?? Future.value(null);
  }

  Future<bool> exists() async {
    final data = await getOrNull();
    return data != null;
  }

  static MemoryDataSource<T> memory<T>({T? initialData}) {
    return MemoryDataSource(initialData: initialData);
  }

  static FileDataSource file(File file) {
    return FileDataSource(file: file);
  }

  static RawFileDataSource rawFile(File file) {
    return RawFileDataSource(file: file);
  }
}

extension DataSourceExtension<T> on DataSource<T> {
  Stream<T> getX() {
    return getXOrNull() ?? (throw Exception('Could not get data stream for [$this]'));
  }

  Future<T> get() async {
    return (await getOrNull()) ?? (throw Exception('Could not get data for [$this]'));
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

abstract class DataSourceWrapper<T> implements DataSource<T> {
  DataSource<T> get dataSource;
}

mixin IsDataSourceWrapper<T> implements DataSourceWrapper<T> {
  @override
  Future<T?> getOrNull() => dataSource.getOrNull();

  @override
  Future<void> set(T data) => dataSource.set(data);

  @override
  Future<void> delete() => dataSource.delete();

  @override
  Future<bool> exists() => dataSource.exists();
}
