import 'package:jlogical_utils/src/pond/modules/asset/asset_upload_modifier.dart';

import '../../../model/export_core.dart';
import '../../../patterns/export_core.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import 'asset.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final AssetProvider assetProvider;
  final List<AssetUploadModifier> assetUploadModifiers;

  final Map<AssetProvider, Cache<String, Model<Asset?>>> _assetCacheByProvider = {};

  AssetModule({required this.assetProvider, this.assetUploadModifiers = const []});

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
    return _getAssetCacheFromProvider(assetProvider).putIfAbsent(
      id,
      () => assetProvider!.getModelById(id)..ensureLoadingStarted(),
    );
  }

  void saveAssetToCache(Asset asset, {AssetProvider? assetProvider}) {
    assetProvider ??= this.assetProvider;

    final id = asset.id!;
    _getAssetCacheFromProvider(assetProvider).putIfAbsent(id, () => assetProvider!.getModelById(id)).setLoaded(asset);
  }

  Future<void> deleteAsset(String id, {AssetProvider? assetProvider}) async {
    assetProvider ??= this.assetProvider;
    _getAssetCacheFromProvider(assetProvider).get(id)?.setLoaded(null);
    await assetProvider.getDataSource(id).delete();
  }

  Future<Asset> getModifiedAsset(Asset asset) async {
    for (final uploadModifier in assetUploadModifiers) {
      asset = await uploadModifier.getModifiedAsset(asset);
    }
    return asset;
  }

  Future<String?> getAssetUploadException(Asset asset) async {
    asset = await getModifiedAsset(asset);

    for (final assetUploadModifier in assetUploadModifiers) {
      final exception = await assetUploadModifier.getException(asset);
      if (exception != null) {
        return exception;
      }
    }
    return null;
  }

  Future<Asset> uploadAsset(Asset asset, {AssetProvider? assetProvider}) async {
    assetProvider ??= this.assetProvider;

    asset = await getModifiedAsset(asset);
    final exception = await getAssetUploadException(asset);
    if (exception != null) {
      throw exception;
    }

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
    _getAssetCacheFromProvider(assetProvider).save(id, loadedModel);

    await asset.clearCachedFile();

    return uploadedAsset;
  }

  Cache<String, Model<Asset?>> _getAssetCacheFromProvider(AssetProvider assetProvider) {
    return _assetCacheByProvider.putIfAbsent(assetProvider, () => Cache());
  }
}
