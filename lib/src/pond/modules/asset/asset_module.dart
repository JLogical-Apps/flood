import 'package:collection/collection.dart';

import '../../../model/export_core.dart';
import '../../../patterns/export_core.dart';
import '../../context/module/app_module.dart';
import 'asset.dart';
import 'asset_picker.dart';
import 'asset_provider.dart';

class AssetModule extends AppModule {
  final List<AssetProvider> assetProviders = [];

  final List<AssetPicker> assetPickers = [];

  final Cache<String, Model> _assetCache = Cache();

  AssetModule withAssetProvider(AssetProvider assetProvider) {
    assetProviders.add(assetProvider);
    return this;
  }

  AssetModule withAssetPicker(AssetPicker assetPicker) {
    assetPickers.add(assetPicker);
    return this;
  }

  Model getAssetModelRuntime({required Type assetType, required String id}) {
    return _assetCache.putIfAbsent(
      _getAssetId(assetType: assetType, id: id),
      () => _getAssetProviderRuntime(assetType).getModelById(id)..ensureLoadingStarted(),
    );
  }

  Model<T?> getAssetModel<A extends Asset<T>, T>(String id) {
    return getAssetModelRuntime(assetType: A, id: id) as Model<T?>;
  }

  Future<void> deleteAssetRuntime({required Type assetType, required String id}) async {
    _assetCache.get(_getAssetId(assetType: assetType, id: id))?.setLoaded(null);
    await _getAssetProviderRuntime(assetType).getDataSource(id).delete();
  }

  Future<void> deleteAsset<A extends Asset>(String id) {
    return deleteAssetRuntime(assetType: A, id: id);
  }

  Future<String> uploadAssetRuntime({required Type assetType, required dynamic value, String? suffix}) async {
    final id = await _getAssetProviderRuntime(assetType).upload(value, suffix: suffix);

    final loadedModel = _getAssetProviderRuntime(assetType).getModelById(id)
      ..hasStartedLoading = true
      ..setLoaded(value);
    _assetCache.save(_getAssetId(assetType: assetType, id: id), loadedModel);

    return id;
  }

  Future<String> uploadAsset<A extends Asset<T>, T>(T value, {String? suffix}) {
    return uploadAssetRuntime(assetType: A, value: value, suffix: suffix);
  }

  Future<A?> pickAsset<A extends Asset<T>, T>() async {
    return _getAssetPicker<A, T>().pickAsset();
  }

  String _getAssetId({required Type assetType, required String id}) {
    return '$assetType/$id';
  }

  AssetProvider? _getAssetProviderOrNullRuntime(Type assetType) {
    return assetProviders.firstWhereOrNull((provider) => provider.assetType == assetType);
  }

  AssetProvider _getAssetProviderRuntime(Type assetType) {
    return _getAssetProviderOrNullRuntime(assetType) ??
        (throw Exception('Could not find AssetProvider that handles [$assetType]'));
  }

  AssetPicker? _getAssetPickerOrNullRuntime(Type assetType) {
    return assetPickers.firstWhereOrNull((provider) => provider.assetType == assetType);
  }

  AssetPicker _getAssetPickerRuntime(Type assetType) {
    return _getAssetPickerOrNullRuntime(assetType) ??
        (throw Exception('Could not find AssetPicker that handles [$assetType]'));
  }

  AssetPicker<A, T> _getAssetPicker<A extends Asset<T>, T>() {
    return _getAssetPickerRuntime(A) as AssetPicker<A, T>;
  }
}
