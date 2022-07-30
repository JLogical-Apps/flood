import 'dart:async';

import '../../../model/export_core.dart';
import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import '../../context/registration/app_registration.dart';
import 'asset.dart';
import 'asset_metadata.dart';

abstract class AssetProvider {
  /// Called when the provider is registered to the asset module.
  void onRegister(AppRegistration registration) {}

  /// Called when the provider is registered and the asset module is reset.
  Future<void> onReset(AppContext context) async {}

  /// Returns the data source associated with [id].
  DataSource<Asset> getDataSource(String id);

  /// Returns the metadata for the asset with [id].
  DataSource<AssetMetadata> getMetadataDataSource(String id);

  /// The id generator to use to generate ids.
  IdGenerator<void, String> get idGenerator => UuidIdGenerator();

  /// Uploads the [asset] and returns an updated one with all the metadata.
  Future<Asset> upload(Asset asset) async {
    final id = asset.id ?? idGenerator.getId(null);

    final dataSource = getDataSource(id);

    await dataSource.saveData(asset);

    final newMetadata = await getMetadataDataSource(id).getData();

    return asset.copyWith(id: id, metadata: newMetadata);
  }

  Model<Asset?> getModelById(String id) {
    return Model(loader: () => getDataSource(id).getData());
  }
}
