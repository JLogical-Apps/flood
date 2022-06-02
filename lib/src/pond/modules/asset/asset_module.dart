import '../../../model/export_core.dart';
import '../../../patterns/export_core.dart';
import '../../context/module/app_module.dart';
import 'asset.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final AssetProvider assetProvider;

  final Cache<String, Model<Asset?>> _assetCache = Cache();

  AssetModule({required this.assetProvider});

  Model<Asset?> getAssetModel(String id) {
    return _assetCache.putIfAbsent(
      id,
      () => assetProvider.getModelById(id)..ensureLoadingStarted(),
    );
  }

  Future<void> deleteAsset(String id) async {
    _assetCache.get(id)?.setLoaded(null);
    await assetProvider.getDataSource(id).delete();
  }

  Future<String> uploadAsset(Asset asset) async {
    final id = await assetProvider.upload(asset);

    final isAlreadyUploaded = asset.id != null;
    if (isAlreadyUploaded) {
      await asset.clearCachedFile();
      getAssetModel(id).setLoaded(asset);
      return id;
    }

    asset = Asset(
      id: id,
      name: asset.name,
      value: asset.value,
    );

    final loadedModel = assetProvider.getModelById(id)
      ..hasStartedLoading = true
      ..setLoaded(asset);
    _assetCache.save(id, loadedModel);

    await asset.clearCachedFile();

    return id;
  }
}
