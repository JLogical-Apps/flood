import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

mixin WithMapperDataSource<P, T> on DataSource<T> {
  DataSource<P> get parent;

  P saveMapped(T obj);

  T? loadMapped(P? obj);

  Future<T?> getData() async {
    final parentData = await parent.getData();
    return loadMapped(parentData);
  }

  Future<void> saveData(T data) async {
    final persisted = saveMapped(data);
    await parent.saveData(persisted);
  }

  Future<void> delete() => parent.delete();
}
