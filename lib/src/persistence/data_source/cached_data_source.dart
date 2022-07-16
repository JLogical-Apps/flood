import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

/// Data source that attempts to get data from cache first, then gets it from a source.
/// When uploading to the data source, saves it to both cache and source.
class CachedDataSource<T> extends DataSource<T> {
  final DataSource<T> sourceDataSource;

  final DataSource<T> cacheDataSource;

  CachedDataSource({required this.sourceDataSource, required this.cacheDataSource});

  @override
  Future<T?> getData() async {
    final existsInCache = await cacheDataSource.exists();
    if (existsInCache) {
      return await cacheDataSource.getData();
    }

    final sourceData = await sourceDataSource.getData();
    if (sourceData != null) {
      await cacheDataSource.saveData(sourceData);
    }

    return sourceData;
  }

  @override
  Future<void> saveData(T data) async {
    await sourceDataSource.saveData(data);
    await cacheDataSource.saveData(data);
  }

  @override
  Future<bool> exists() async {
    final existsInCache = await cacheDataSource.exists();
    if (existsInCache) {
      return true;
    }

    return await sourceDataSource.exists();
  }

  @override
  Future<void> delete() async {
    await sourceDataSource.delete();
    await cacheDataSource.delete();
  }
}
