import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_metadata.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

const timeoutDuration = Duration(seconds: 4);

class CacheAssetProvider with IsAssetProviderWrapper {
  final AssetProvider sourceAssetProvider;
  final AssetProvider cacheAssetProvider;

  final Map<(AssetPathContext, String), AssetReference> _sourceAssetReferenceById = {};
  final Map<(AssetPathContext, String), AssetReference> _cacheAssetReferenceById = {};

  final Map<(AssetPathContext, String), BehaviorSubject<FutureValue<AssetMetadata>>> _assetMetadataXById = {};
  final Map<(AssetPathContext, String), BehaviorSubject<FutureValue<Asset>>> _assetXById = {};

  CacheAssetProvider({required this.sourceAssetProvider, required this.cacheAssetProvider});

  @override
  AssetProvider get assetProvider => sourceAssetProvider;

  @override
  AssetReference getById(AssetPathContext context, String id) {
    final key = (context, id);
    return AssetReference(
      id: id,
      assetMetadataModel: Model.fromValueStream(
        _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())),
        onLoad: () => getLatestAssetMetadata(context, id),
      ),
      assetModel: Model.fromValueStream(
        _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())),
        onLoad: () async {
          await getLatestAssetMetadata(context, id, waitForAsset: true);
        },
      ),
    );
  }

  Future<AssetMetadata?> getLatestAssetMetadata(
    AssetPathContext context,
    String id, {
    bool waitForAsset = false,
  }) async {
    final key = (context, id);
    if (_assetMetadataXById[key]?.value.isLoaded ?? false) {
      return _assetMetadataXById[key]!.value.getOrNull()!;
    }

    final sourceAssetReference =
        _sourceAssetReferenceById.putIfAbsent(key, () => sourceAssetProvider.getById(context, id));
    final cacheAssetReference =
        _cacheAssetReferenceById.putIfAbsent(key, () => cacheAssetProvider.getById(context, id));

    final [sourceAssetMetadata, cachedAssetMetadata] = await Future.wait([
      guardAsync(() => sourceAssetReference.assetMetadataModel.getOrLoad().timeout(timeoutDuration)),
      guardAsync(() => cacheAssetReference.assetMetadataModel.getOrLoad())
    ]);
    if (sourceAssetMetadata != null || cachedAssetMetadata != null) {
      _assetMetadataXById[key]!.value = FutureValue.loaded(sourceAssetMetadata ?? cachedAssetMetadata!);
    }

    final needsUpdating = cachedAssetMetadata == null ||
        (sourceAssetMetadata != null &&
            cachedAssetMetadata.updatedTime.isBefore(sourceAssetMetadata.updatedTime.subtract(Duration(seconds: 30))));
    if (needsUpdating) {
      if (waitForAsset) {
        await downloadSource(context, id);
      } else {
        downloadSource(context, id);
      }
    } else if (_assetXById[key]?.value.isLoaded != true) {
      final cacheAsset = await guardAsync(() => cacheAssetReference.assetModel.getOrLoad());
      if (cacheAsset != null) {
        _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
            FutureValue.loaded(cacheAsset);
      }
    }

    return sourceAssetMetadata;
  }

  Future<void> downloadSource(AssetPathContext context, String id) async {
    final key = (context, id);
    final sourceAsset = await guardAsync(() => sourceAssetProvider.getById(context, id).assetModel.getOrLoad());
    if (sourceAsset == null) {
      return;
    }

    await cacheAssetProvider.upload(context, sourceAsset);

    _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset.metadata);
    _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset);
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final key = (context, asset.id);
    _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.loaded(asset))).value =
        FutureValue.loaded(asset);
    _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.loaded(asset.metadata))).value =
        FutureValue.loaded(asset.metadata);

    final sourceAsset = await sourceAssetProvider.upload(context, asset);
    await cacheAssetProvider.upload(context, sourceAsset);

    return sourceAsset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    final key = (context, id);
    await sourceAssetProvider.delete(context, id);
    await cacheAssetProvider.delete(context, id);
    _assetMetadataXById[key]?.value = FutureValue.empty();
    _assetMetadataXById.remove(key);
    _assetXById[key]?.value = FutureValue.empty();
    _assetXById.remove(key);
  }
}
