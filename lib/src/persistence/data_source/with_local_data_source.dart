import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

/// Data source that stores its data locally.
mixin WithLocalDataSource<T> on DataSource<T> {
  T? get initialData => null;

  /// The current data pointed to by the data source.
  late T? _data = initialData;

  @override
  Future<bool> exists() async {
    return _data != null;
  }

  @override
  Future<T?> getData() async {
    return _data;
  }

  @override
  Future<void> saveData(T data) async {
    this._data = data;
  }

  @override
  Future<void> delete() async {
    _data = null;
  }
}
