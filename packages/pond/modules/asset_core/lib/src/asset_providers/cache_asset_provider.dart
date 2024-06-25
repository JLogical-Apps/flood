import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_metadata.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class CacheAssetProvider with IsAssetProvider {
  final AssetProvider sourceAssetProvider;
  final AssetProvider cacheAssetProvider;

  final Map<String, AssetReference> _sourceAssetReferenceById = {};
  final Map<String, AssetReference> _cacheAssetReferenceById = {};

  final Map<String, BehaviorSubject<FutureValue<AssetMetadata>>> _assetMetadataXById = {};
  final Map<String, BehaviorSubject<FutureValue<Asset>>> _assetXById = {};

  CacheAssetProvider({required this.sourceAssetProvider, required this.cacheAssetProvider});

  @override
  AssetReference getById(AssetPathContext context, String id) {
    return AssetReference(
      id: id,
      assetMetadataModel: Model.fromValueStream(
        _assetMetadataXById.putIfAbsent(id, () => BehaviorSubject.seeded(FutureValue.empty())),
        onLoad: () => getLatestAssetMetadata(context, id),
      ),
      assetModel: Model.fromValueStream(
        _assetXById.putIfAbsent(id, () => BehaviorSubject.seeded(FutureValue.empty())),
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
    final sourceAssetReference =
        _sourceAssetReferenceById.putIfAbsent(id, () => sourceAssetProvider.getById(context, id));
    final cacheAssetReference = _cacheAssetReferenceById.putIfAbsent(id, () => cacheAssetProvider.getById(context, id));

    final [sourceAssetMetadata, cachedAssetMetadata] = await Future.wait([
      guardAsync(() => sourceAssetReference.assetMetadataModel.getOrLoad()),
      guardAsync(() => cacheAssetReference.assetMetadataModel.getOrLoad())
    ]);
    if (sourceAssetMetadata != null || cachedAssetMetadata != null) {
      _assetMetadataXById[id]!.value = FutureValue.loaded(sourceAssetMetadata ?? cachedAssetMetadata!);
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
    } else if (_assetXById[id]?.value.isLoaded != true) {
      final cacheAsset = await guardAsync(() => cacheAssetReference.assetModel.getOrLoad());
      if (cacheAsset != null) {
        _assetXById.putIfAbsent(id, () => BehaviorSubject.seeded(FutureValue.empty())).value =
            FutureValue.loaded(cacheAsset);
      }
    }

    return sourceAssetMetadata;
  }

  Future<void> downloadSource(AssetPathContext context, String id) async {
    final sourceAsset = await guardAsync(() => sourceAssetProvider.getById(context, id).assetModel.getOrLoad());
    if (sourceAsset == null) {
      return;
    }

    await cacheAssetProvider.upload(context, sourceAsset);

    _assetMetadataXById.putIfAbsent(id, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset.metadata);
    _assetXById.putIfAbsent(id, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset);
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    _assetXById.putIfAbsent(asset.id, () => BehaviorSubject.seeded(FutureValue.loaded(asset))).value =
        FutureValue.loaded(asset);
    _assetMetadataXById.putIfAbsent(asset.id, () => BehaviorSubject.seeded(FutureValue.loaded(asset.metadata))).value =
        FutureValue.loaded(asset.metadata);

    final sourceAsset = await sourceAssetProvider.upload(context, asset);
    await cacheAssetProvider.upload(context, sourceAsset);

    return sourceAsset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    await sourceAssetProvider.delete(context, id);
    await cacheAssetProvider.delete(context, id);
    _assetMetadataXById[id]?.value = FutureValue.empty();
    _assetMetadataXById.remove(id);
    _assetXById[id]?.value = FutureValue.empty();
    _assetXById.remove(id);
  }
}
