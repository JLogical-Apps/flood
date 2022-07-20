import 'dart:async';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

mixin WithMapperDataSource<P, T> on DataSource<T> {
  DataSource<P> get parent;

  FutureOr<P> saveMapped(T obj);

  FutureOr<T?> loadMapped(P? obj);

  @override
  Future<T?> getData() async {
    final parentData = await parent.getData();
    return await loadMapped(parentData);
  }

  @override
  Future<void> saveData(T data) async {
    final persisted = await saveMapped(data);
    await parent.saveData(persisted);
  }

  @override
  Future<bool> exists() async {
    return parent.exists();
  }

  Future<void> delete() => parent.delete();
}
