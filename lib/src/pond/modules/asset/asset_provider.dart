import '../../../model/export_core.dart';
import '../../../persistence/export_core.dart';
import 'asset.dart';

abstract class AssetProvider<A extends Asset<T>, T> {
  /// Returns the data source associated with [id].
  DataSource<T> getDataSource(String id);

  /// Uploads [value] and returns its id.
  Future<String> upload(T value);

  Type get assetType => A;

  Model<T?> getModelById(String id) {
    return Model(loader: () => getDataSource(id).getData());
  }
}
