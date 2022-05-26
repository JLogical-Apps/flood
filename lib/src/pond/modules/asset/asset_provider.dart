import '../../../model/export_core.dart';
import '../../../persistence/export_core.dart';
import 'asset.dart';

abstract class AssetProvider<A extends Asset<T>, T> {
  /// Returns the data source associated with [id].
  DataSource<T> getDataSource(String id);

  /// The id generator to use to generate ids.
  IdGenerator<T, String> get idGenerator => UuidIdGenerator();

  /// Uploads [value] and returns its id.
  Future<String> upload(T value, {String? suffix}) async {
    var id = idGenerator.getId(value);
    if (suffix != null) {
      id += suffix;
    }

    final dataSource = getDataSource(id);

    await dataSource.saveData(value);

    return id;
  }

  Type get assetType => A;

  Model<T?> getModelById(String id) {
    return Model(loader: () => getDataSource(id).getData());
  }
}
