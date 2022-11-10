import 'dart:async';

import 'package:persistence_core/src/data_source.dart';
import 'package:utils_core/utils_core.dart';

class MapperDataSource<T, T2> extends DataSource<T2> {
  final DataSource<T> dataSource;

  final FutureOr<T2> Function(T data) getMapper;
  final FutureOr<bool> Function(T? data)? existsMapper;
  final FutureOr<T> Function(T2 data) setMapper;
  final FutureOr<void> Function()? deleteMapper;

  MapperDataSource({
    required this.dataSource,
    required this.getMapper,
    this.existsMapper,
    required this.setMapper,
    this.deleteMapper,
  });

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
        super.exists();
  }

  @override
  Future<void> set(T2 data) async {
    dataSource.set(await setMapper(data));
  }

  @override
  Future<void> delete() async {
    await Future(() => deleteMapper.mapIfNonNull((mapper) => mapper()) ?? dataSource.delete());
  }
}
