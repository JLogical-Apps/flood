import 'dart:async';

import 'package:persistence_core/src/data_source.dart';
import 'package:utils_core/utils_core.dart';

abstract class MapperDataSource<T, T2> with IsDataSource<T2> {
  DataSource<T> get dataSource;

  FutureOr<T2> Function(T data) get getMapper;

  FutureOr<bool> Function(T? data)? get existsMapper;

  FutureOr<T> Function(T2 data) get setMapper;

  FutureOr<void> Function()? get deleteMapper;

  factory MapperDataSource({
    required DataSource<T> dataSource,
    required FutureOr<T2> Function(T data) getMapper,
    required FutureOr<bool> Function(T? data)? existsMapper,
    required FutureOr<T> Function(T2 data) setMapper,
    required FutureOr<void> Function()? deleteMapper,
  }) =>
      _MapperDataSourceImpl(
        dataSource: dataSource,
        getMapper: getMapper,
        setMapper: setMapper,
      );
}

mixin IsMapperDataSource<T, T2> implements MapperDataSource<T, T2> {
  @override
  Stream<T2>? getXOrNull() {
    return dataSource.getXOrNull()?.asyncMap((value) => getMapper(value));
  }

  @override
  Future<T2?> getOrNull() async {
    final originalData = await dataSource.getOrNull();
    final mapped = await (originalData.mapIfNonNull((data) async => await getMapper(data)));
    return mapped;
  }

  @override
  Future<bool> exists() async {
    return existsMapper.mapIfNonNull((mapper) async {
          final data = await dataSource.getOrNull();
          return await mapper(data);
        }) ??
        dataSource.exists();
  }

  @override
  Future<void> set(T2 data) async {
    await dataSource.set(await setMapper(data));
  }

  @override
  Future<void> delete() async {
    await Future(() => deleteMapper.mapIfNonNull((mapper) => mapper()) ?? dataSource.delete());
  }
}

class _MapperDataSourceImpl<T, T2> with IsMapperDataSource<T, T2> {
  @override
  final DataSource<T> dataSource;

  @override
  final FutureOr<T2> Function(T data) getMapper;

  @override
  final FutureOr<bool> Function(T? data)? existsMapper;

  @override
  final FutureOr<T> Function(T2 data) setMapper;

  @override
  final FutureOr<void> Function()? deleteMapper;

  _MapperDataSourceImpl({
    required this.dataSource,
    required this.getMapper,
    this.existsMapper,
    required this.setMapper,
    this.deleteMapper,
  });
}
