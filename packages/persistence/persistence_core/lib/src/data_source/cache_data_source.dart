import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class CacheDataSource<T> with IsDataSourceWrapper<T> {
  @override
  final DataSource<T> dataSource;

  final CachePolicy cachePolicy;

  late final Cache<T?> _cache = Cache(() => dataSource.getOrNull(), cachePolicy: cachePolicy);

  CacheDataSource({required this.dataSource, CachePolicy? cachePolicy})
      : cachePolicy = cachePolicy ?? CachePolicy.timed(Duration(minutes: 1));

  @override
  Stream<T>? getXOrNull() {
    throw Exception('Cannot get a stream of values from a cache!');
  }

  @override
  Future<T?> getOrNull() {
    return _cache.get();
  }

  @override
  Future<void> set(T data) async {
    await super.set(data);
    _cache.set(data);
  }

  @override
  Future<void> delete() async {
    await super.delete();
    _cache.clear();
  }

  @override
  Future<bool> exists() async {
    if (_cache.value.isLoaded) {
      return true;
    }

    return await super.exists();
  }
}
