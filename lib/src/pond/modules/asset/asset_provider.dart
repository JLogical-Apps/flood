import '../../../model/export_core.dart';
import '../../../persistence/export_core.dart';
import 'asset.dart';

abstract class AssetProvider {
  /// Returns the data source associated with [id].
  DataSource<Asset> getDataSource(String id);

  /// The id generator to use to generate ids.
  IdGenerator<Asset, String> get idGenerator => UuidIdGenerator();

  /// Uploads [value] and returns its id.
  Future<String> upload(Asset asset) async {
    final id = asset.id ?? (idGenerator.getId(asset) + asset.name);

    final dataSource = getDataSource(id);

    await dataSource.saveData(asset);

    return id;
  }

  Model<Asset?> getModelById(String id) {
    return Model(loader: () => getDataSource(id).getData());
  }
}
