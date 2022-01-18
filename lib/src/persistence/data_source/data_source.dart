/// A data source is a special service that reads and updates data from a particular source.
/// [T] is the type of data this data source points to.
abstract class DataSource<T> {
  /// Returns the data at the data source or null if not found.
  Future<T?> getData();

  /// Saves [data] into the data source.
  Future<void> saveData(T data);

  /// Deletes the data source.
  Future<void> delete();
}
