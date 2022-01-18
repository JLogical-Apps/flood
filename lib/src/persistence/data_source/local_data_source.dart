import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

/// Data source that stores its data locally.
class LocalDataSource<T> implements DataSource<T> {
  /// The current data pointed to by the data source.
  T? data;

  LocalDataSource({T? initialData}) : data = initialData;

  @override
  Future<T?> getData() async {
    return data;
  }

  @override
  Future<void> saveData(T data) async {
    this.data = data;
  }

  @override
  Future<void> delete() async {
    data = null;
  }
}
