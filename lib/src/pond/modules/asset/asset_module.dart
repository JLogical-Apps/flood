import 'package:collection/collection.dart';

import '../../../model/export_core.dart';
import '../../../patterns/export_core.dart';
import '../../context/module/app_module.dart';
import 'asset.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final List<AssetProvider> assetProviders = [];

  final Cache<String, Model> _assetCache = Cache();

  AssetModule withAssetProvider(AssetProvider assetProvider) {
    assetProviders.add(assetProvider);
    return this;
  }

  Model getAssetModelRuntime({required Type assetType, required String id}) {
    return _assetCache.putIfAbsent(
      _getAssetId(id),
      () => _getAssetProviderRuntime(assetType).getModelById(id)..ensureLoadingStarted(),
    );
  }

  Model<T?> getAssetModel<A extends Asset<T>, T>(String id) {
    return getAssetModelRuntime(assetType: A, id: id) as Model<T?>;
  }

  Future<void> deleteAssetRuntime({required Type assetType, required String id}) async {
    _assetCache.remove(_getAssetId(id));
    await _getAssetProviderRuntime(assetType).getDataSource(id).delete();
  }

  Future<void> deleteAsset<A extends Asset>(String id) {
    return deleteAssetRuntime(assetType: A, id: id);
  }

  Future<String> uploadAssetRuntime({required Type assetType, required dynamic value}) async {
    final id = await _getAssetProviderRuntime(assetType).upload(value);

    final loadedModel = _getAssetProviderRuntime(assetType).getModelById(id)
      ..hasStartedLoading = true
      ..setLoaded(value);
    _assetCache.save(_getAssetId(id), loadedModel);

    return id;
  }

  Future<String> uploadAsset<A extends Asset<T>, T>(T value) {
    return uploadAssetRuntime(assetType: A, value: value);
  }

  String _getAssetId<A extends Asset>(String id) {
    return '$A/id';
  }

  AssetProvider? _getAssetProviderOrNullRuntime(Type assetType) {
    return assetProviders.firstWhereOrNull((provider) => provider.assetType == assetType);
  }

  AssetProvider _getAssetProviderRuntime(Type assetType) {
    return _getAssetProviderOrNullRuntime(assetType) ??
        (throw Exception('Could not find AssetProvider that handles [$assetType]'));
  }
}
