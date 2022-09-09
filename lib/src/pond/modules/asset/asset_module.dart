import '../../../model/export_core.dart';
import '../../../patterns/export_core.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import 'asset.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final AssetProvider assetProvider;

  final Cache<String, Model<Asset?>> _assetCache = Cache();

  AssetModule({required this.assetProvider});

  @override
  void onRegister(AppRegistration registration) {
    assetProvider.onRegister(registration);
  }

  @override
  Future<void> onReset(AppContext context) {
    return assetProvider.onReset(context);
  }

  Model<Asset?> getAssetModel(String id, {AssetProvider? assetProvider}) {
    assetProvider ??= this.assetProvider;
    return _assetCache.putIfAbsent(
      id,
      () => assetProvider!.getModelById(id)..ensureLoadingStarted(),
    );
  }

  void saveAssetToCache(Asset asset) {
    final id = asset.id!;
    _assetCache.putIfAbsent(id, () => assetProvider.getModelById(id)).setLoaded(asset);
  }

  Future<void> deleteAsset(String id) async {
    _assetCache.get(id)?.setLoaded(null);
    await assetProvider.getDataSource(id).delete();
  }

  Future<Asset> uploadAsset(Asset asset) async {
    final uploadedAsset = await assetProvider.upload(asset);
    final id = uploadedAsset.id!;

    final isAlreadyUploaded = asset.id != null;
    if (isAlreadyUploaded) {
      await asset.clearCachedFile();
      getAssetModel(id).setLoaded(uploadedAsset);
      return uploadedAsset;
    }

    final loadedModel = assetProvider.getModelById(id)
      ..hasStartedLoading = true
      ..setLoaded(uploadedAsset);
    _assetCache.save(id, loadedModel);

    await asset.clearCachedFile();

    return uploadedAsset;
  }
}
